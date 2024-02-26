# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

50.times do
  tipo_chave = ['CPF', 'CNPJ', 'Telefone', 'E-mail'].sample # Escolher aleatoriamente um tipo de chave PIX
  chave_pix = case tipo_chave
              when 'CPF'
                Faker::IDNumber.brazilian_citizen_number(formatted: true)
              when 'CNPJ'
                Faker::Company.brazilian_company_number(formatted: true)
              when 'Telefone'
                Faker::PhoneNumber.cell_phone
              when 'E-mail'
                Faker::Internet.unique.email
              end

  UsuarioPix.create({
    id_usuario: Faker::Number.unique.number(digits: 2), # Gerar um número de 10 dígitos único
    chave_pix: chave_pix,
    tipo_chave: tipo_chave,
    saldo: Faker::Number.decimal(l_digits: 2), # Gerar um número decimal com 2 casas decimais para simular o saldo
    chave_ativa: Faker::Boolean.boolean # Gerar um valor booleano para simular se a chave PIX está ativa ou não
  })
end