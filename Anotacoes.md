## S1A5 - Criando o primeiro CRUD/Scaffold

# Criando CRUD
rails g scaffold <Tabela> <campo>:<tipo>
rails g scaffold Contact name: spring birthdate: date

# Migrando Tabela
rails db:migrate

# Executando servidor
rails s -b 0.0.0.0

# Info de rotas
http://localhost:3000/rails/info/routes

# Vendo tarefas
rails -T

# Criando tarefa
rails g task <nome> setup #Configura o ambiente de desenvolvimento
rails g task dev setup

## S1A7 - Recursos

# Resources
Recursos são elementos de informação, ou seja, em config/routes.rb, quando você define uma rota como recurso, o próprio Rails vai mapear esse recurso baseando no REST. As URLs GET, POST etc são criadas automaticamente a partir dos recursos.
Por padrão, o nome do recurso deve ser feito no plural e devem ser substantivos. Ex.: contacts
Também é possível redirecionar rotas da seguinte forma:
get '/contacts', to: "contacts#index"

## S1A8 - Analisando as Requisições HTTP

# Requisições
Request é um recurso que você pede através da interface e o servidor pode resolver um dado JSON.
É a forma que temos de nos comunicar com o servidor.
Em uma requisição podemos informar:
- URL (required)
http://localhost:3000/contacts
- Parâmetros (optional)
http://localhost:3000/contacts?param1=123&param2=567
- Método/verbo HTTP (required)
GET, POST, DELETE, PATCH (existem mais)
Se não informar nada, o padrão é GET
GET - receber
POST - enviar
DELETE - apagar
PATCH - atualizar
- Campos de cabeçalho/header fields (optional)
Accept: application/json
Accept: */*
- Dados adicionais (optional)

# No curl
curl http://localhost:3000/contacts -v -X GET

## S1A9 - Analisando as Respostas HTTP

# Respostas
A resposta a uma requisição pode conter:
- Start-Line
-- Request-Line: Versão do HTTP que foi usada
-- Status-Line: 200 OK - representa que houve uma resposta
- Header Fields
Metadados da requisição e resposta HTTP contendo informações sobre como a transferência dos dados deve ser manipulada
-- Content-Type: application/json: informa o tipo de retorno que o servidor enviou
- Empty Line
Linha em branco que separa o cabeçalho inicial do corpo da mensagem
- Message-Body
Corpo da mensagem que contém os dados da resposta da requisição feita

# No curl
curl http://localhost:3000/contacts -i

## S1A10 - Conhecendo os Verbos HTTP

#cURL
- GET
curl http://localhost:3000/contacts -i -v
-i -> Dados do cabeçalho
-v -> Dados da requisição
- POST
curl http://localhost:3000/contacts -i -v -X POST -H "Content-Type: application/json" -d '{"name": "Lauren", "email": "lauren.ferremch@gmail.com"}'
-H -> Avisa que vai enviar um header field
-X -> Especifica o verbo
-d -> Dados enviados
- GET
curl http://localhost:3000/contacts/102
Retorna dados do ID 102
- PATCH
curl http://localhost:3000/contacts/102 -i -v -X PATCH -H "Content-Type: application/json" -d '{"name": "Lauren Ferreira", "email": "laurenmariaferreira@outlook.com"}'
- DELETE
curl http://localhost:3000/contacts/102 -i -v -X DELETE

## S1A11 - REST? RESTful

# REST
Representational State Transfer
Tese de Ph.D do cientista Roy Field, um dos principais autores da especificação do protocolo HTTP.
Formalização de um conjunto de melhores práticas (constraints).
- Cliente/Servidor
Separar as responsabilidades de diferentes partes de um sistema.
- Stateless
Cada requisição ao servidor não deve ter ligação com requisições anteriores ou futuras, ou seja, cada requisição deve conter todas as informações necessáris para que ela seja tratada com sucesso pelo servidor.
- Cache
Para melhor performance
- Interface uniforme
Leva muito esforço para que o sistema possua uma interface modelada como:
-- Recursos
-- Mensagens autodescritivas
-- Hypermedia
- Sistema em camadas
Para permitir a escalabilidade necessária para grandes sistemas distribuídos, um sistema REST deve ser capaz de adicionar elementos intermediários e que sejam totalmente transparentes para seus clientes. Ex: Balanceador de Carga
- Código sob demanda (opcional)
Aumentar a flexibilidade dos clientes. Ex: um código javascript só é baixado quando uma determinada página é carregada
- REST é um conjunto de melhores práticas denominadas constraints. Se uma API não segue os princípios REST, teremos apenas uma API HTTP
- Se temos uma API que implementa essas características, é uma implementação RESTful

## S1A12 - Conhecendo os HTTP Status Code

# Internet Task Force - IETF
www.ietf.org
Instituição que especifica os padrões que serão implementados e utilizados em toda a Internet.

# RFC - Request for Comments
Documentos técnicos mantidos pelo IETF

# Classes
- 1xx Informational
- 2xx Success (entre o cliente e o servidor)
- 3xx Reditection (passo adicional)
- 4xx Client Error
- 5xx Server Error
https://httpstatuses.com/

## S1A13 - HTTP Status Code no Ruby on Rails
status: :rails_code
Ex.:
render json: @contact, status: :created, location: @contact
É necessário executar o servidor novamente para essas alterações valerem

## S1A14 - Map/Collect
https://ruby-doce.org/core-2.2.0/Array.html#method-i-map
x = [1,2,3,4,5]
x.class => Array
x.map { |i| ix3 } => [3, 6, 9, 12, 15]
x.collect { |i| ix3 } => [3, 6, 9, 12, 15]
-> Criam um novo array
y = x.map ...
-> Para alterar o próprio
x.collect! { |i| ix3 }

## S1A14 - Render JSON / Fix Auto-Reloading

# Fix Auto-Reloading
SÓ PARA DESENVOLVIMENTO
config/enviroments/development.rb
  config.file_watcher = ActiveSupport::FileUpdateChecker

# Render JSON
Responsável pela resposta da request transformando o objeto em um json
- Active Support JSON
- Active Model Serializers JSON
Por baixo dos panos:
render json: @contact.as_json.to_json

# Rails c
Rails console
No back -> rails c

#to_json
Cria uma string

#as_json
Pega um objeto e transforma em hash

# Root
root: true
Sem root:
[
    {
        "id": 5,
        "name": Lauren
    }
]
Com root:
[
    "contacts": {
        "id": 5,
        "name": Lauren
    }
]

# Only e except
only: [:name, :email] - apenas nome e email
except: [:name, :email] - todos menos nome e email

# Map & Merge
@contacts.map{|contact|contact.attributes.merge({author:"Lauren})}
Mapeia os contatos, acessa os atributos e adiciona um outro atributo à resposta
Com 1 contato não é necessário map

# methods
Mesmo que o de cima, mais prático
methods: :author
models/contact.rb

# as_json
Se quiser um retorno padrão, já que o render já usa esse método por baixo dos panos, podemos renderizá-lo
models/contact.rb
def as_json(options={})
        super(methos: :author, root: true)
end

## S1A16 - Adicionando novo CRUD
rails g migration add_kind_to_contact kind:references
O Rails gera uma migração adicionando a referência de kind para contato, basicamente indicando kind_id como chave estrangeira
rails g scaffold Kind description:string
Gera o CRUD
rails db:migrate
Manda a migração para o BD

# dev.rake
    puts "Cadastrando os tipos de contatos..."

    kinds = %w(Amigo Comercial Conhecido)

    kinds.each do |contact|
      Kind.create!(
        description: kind
      )
    end

    puts "Tipos de contatos cadastrados com sucesso!"

# Atualiza tabela
rails db:drop db:create db:migrate dev:setup

# contact.rb
belongs_to :kind

# dev.rake
Dentro da criação de Contact
kind: Kind.all.sample
