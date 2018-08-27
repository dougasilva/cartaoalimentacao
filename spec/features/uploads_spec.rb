require 'rails_helper'

RSpec.feature "Uploads", type: :feature do
  scenario 'Upload de arquivo válido' do
    
    visit new_arquivo_path
    page.attach_file('file', Rails.root.join('spec', 'fixtures', 'dados-20-07-2018.csv'))
    click_on('Importar')

    expect(page).to have_content 'Dados Importados' 
  end

  scenario 'Não permite importar sem arquivo selecionado' do
    visit new_arquivo_path
    click_on('Importar')

    expect(page).to have_content 'Selecione um arquivo' 
  end
end
