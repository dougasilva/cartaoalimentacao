class Arquivo < ApplicationRecord
  validates :name, :surname, presence: true, length: { maximum:50 }
  validates :available_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              on: :create }, presence: true
  
  require 'csv'

  def self.import(file)
    @countErros = 0
    @countImportados = 0
    @countAtualizados = 0
    @countTotal = 0
    CSV.foreach(file.path, headers: true) do |row|
      if isValid?(row)
        ln = row.to_hash
        arquivo = Arquivo.where( name: ln['name'], surname: ln['surname'] )
        ln['admission_date'] = Date.parse(ValidaData(ln['admission_date']))
        
        if arquivo.count > 0
          arquivo.first.update(ln)
          @countAtualizados +=1
        else
          arquivo.create!(ln)
          @countImportados +=1
        end
      else
        @countErros = @countErros + 1
      end
      @countTotal +=1
    end

    retorno(@countImportados, @countAtualizados, @countErros, @countTotal)
  end

  def self.isValid?(row)
    p = Arquivo.new
    p.name = row['name']
    p.surname = row['surname']
    p.email = row['email']
    p.token = row['token']
    p.admission_date = ValidaData(row['admission_date'])
    p.available_amount = row['available_amount']
    
    p.valid?
  end
  
  def self.retorno(countImportados, countAtualizados, countErros, countTotal)
    retorno = "Total de linhas: #{countTotal}. 
               Linhas Novas: #{countImportados}.
               Linhas Atualizadas: #{countAtualizados}.
               Linhas com Erro: #{countErros}"
  end

  def self.ValidaData(data)
    "#{data[6..7]}/#{data[3..4]}/#{data[0..1]}"
  end

  def self.antigos(data)
    Arquivo.where('admission_date < ?', data).order('name ASC')
  end

  def self.novos(data)
    Arquivo.where('admission_date > ?', data).order('name ASC')
  end
end
