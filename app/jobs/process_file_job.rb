# app/jobs/process_file_job.rb
class ProcessFileJob < ApplicationJob
  queue_as :default

  def perform(blob_id)
    blob = ActiveStorage::Blob.find(blob_id)
    Rails.logger.info "Processing file blob ID: #{blob.id}"

    # Baixar o arquivo para o sistema de arquivos temporário
    file_path = Rails.root.join("tmp", "uploads", blob.filename.to_s)
    FileUtils.mkdir_p(file_path.dirname) # Garantir que o diretório exista

    # Salvar o arquivo no sistema de arquivos temporário
    File.open(file_path, "wb") do |file|
      file.write(blob.download)
    end

    Rails.logger.info "File downloaded to: #{file_path}"

    # Processar o arquivo
    begin
      File.open(file_path, "r:UTF-8") do |file|
        file.each_line do |line|
          Rails.logger.info "Processing line: #{line}"
          title, body, tags = line.strip.split(';')

          if title.nil? || body.nil? || tags.nil?
            Rails.logger.error "Invalid line format: #{line}"
            next
          end

          post = Post.new(title: title.strip, body: body.strip, user_id: 1) # Assumindo que o usuário com ID 1 é o autor
          post.tag_list = tags.strip
          if post.save
            Rails.logger.info "Created post: #{post.title} with tags: #{post.tag_list}"
          else
            Rails.logger.error "Failed to save post: #{post.errors.full_messages.join(', ')}"
          end
        end
      end
    rescue StandardError => e
      Rails.logger.error "Failed to process file: #{e.message}"
    ensure
      # Remover o arquivo temporário
      FileUtils.rm(file_path)
    end
  end
end
