class ArquivosController < ApplicationController
  def index
    @antigos = Arquivo.antigos(1.year.ago).page(params[:antigo])
    @novos = Arquivo.novos(1.year.ago).page(params[:novo])
  end

  def new; end
  

  def import
    if params[:file]
      @notice = Arquivo.import(params[:file])
      flash[:success] = "Dados do Arquivo Importados. #{@notice}"
      redirect_to arquivos_url
    else
      flash[:danger] = 'Selecione um arquivo.'
      redirect_to new_arquivo_path
    end
  end
end
