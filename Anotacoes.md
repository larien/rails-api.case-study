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

## S1A17 - Render JSON com associações

#belongs_to
Ele é obrigatório por padrão
Para alterar:
belongs_to :kind, optional: true
Mas dessa forma, em um POST, o sistema não reconhece o campo e ele precisa ser liberado nos parâmetros da controller
-> contatcs_controller
    def contact_params
      params.require(:contact).permit(:name, :email, :birthdate, :kind_id)
    end

## S1A18 - Entendendo o i18n
Internacionalização
Traduções ficam em config/location
Configurações ficam em initializers separados depois de Rails 4

# rails-i18n
https://github.com/svenfuchs/rails-i18n
No Gemfile
gem 'rails-i18n', '~> 5.0.0'
I18n.translate('hello')
ou I18n.t('hello')
=> Olá, mundo
Verifica a língua
I18n.default_locale
Troca para inglês
I18n.default_locale = :en
Ou
I18n.l

## S1A20 - i18n para data
    def birthdate_br
       I18n.l(self.birthdate) unless self.birthdate.blank?
    end

Traz a tradução em pt-BR e só mostra a original se a br vier vazia

## S1A21 - Novo model Phones (Associação has_many)

# Criando
rails g model Phone number:string contact:references

# Na classe
has_many :phones
Para indicar uma relação 1:N
Um contato tem vários telefones, mas um telefone só pertence a um contato

# Em dev.rake
    puts "Cadastrando os telefones..."
    Contact.all.each do |contact|
      Random.rand(5).times do |i|
        phone = Phone.create!(number:Faker::PhoneNumber.cell_phone)
        contact.phones << phone
        contact.save!
      end
    end
    puts "Telefones cadastrados com sucesso!"

Percorre todos os contatos. Gera um número de telefone aleatório cinco vezes criando um phone, recebendo um número fake nele e jogando para os phones do contato e por fim salvando.

rails db:drop db:create db:migrate dev:setup
Derruba, cria, migra e executa o scrip que popula as bases

## S1A22 - i18n para data (as_json)

# contact.rb
    def as_json(options={})
        h = super(options)
        h[:birthdate] = (I18n.l(self.birthdate) unless self.birthdate.blank?)
        h
    end

## S1A23 - Nested attributes com has_many

# Pry-Rails
gem 'pry-rails'

# Criando contato no rails console
Contact.create(name: "Lauren", email: "lauren.ferremch@gmail.com, birthdate:"10/10/2010", kind_id: 3)

# Colocando em params
params = {
    contact: {
        name: "Lauren",
        email: "lauren@lauren",
        birthdate: "10/10/2010",
        kind_id: 3
    }
}

# Criando com params
Contact.create(params[:contact])

# Atributos aninhados
params = {
    contact: {
        name: "Lauren",
        email: "lauren@lauren",
        birthdate: "10/10/2010",
        kind_id: 3,
        phones_attributes: [
            { number: '1234' },
            { number: '5262' },
            { number: '0485' }
        ]
    }
}

## S1A24 - CRUD com nested attributes

# CRUD
Create
Read (include)
Update
Delete

# Enviando JSON :contacts
{
    "contacts":
    {
        "name": "Lauren Ferreira",
        "email": "lauren@lauren.com",
        "birthdate": "31/08/2018",
        "kind_id": 3,
        "phones_attributes":[
            {
                "number, "1111111111111"
            },
            {
                "number, "2222222222222"
            }
        ]
    }
}

# Liberando atributo na controller
    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(
        :name, :email, :birthdate, :kind_id,
        phones_attributes [:number])
    end

# PATCH :contacts
Quando não informamos o id do número, ele cria outro
{
    "contacts":
    {
        "name": "Lauren Ferreira",
        "email": "lauren@lauren.com",
        "birthdate": "31/08/2018",
        "kind_id": 3,
        "phones_attributes":[
            {
                "id": "185",
                "number", "1111111111111"
            },
            {
                "id": "192",
                "number", "2222222222222"
            }
        ]
    }
}

# Deletando
Através de um contato eu consigo apagar um telefone?
{
    "contacts":
    {
        "name": "Lauren Ferreira",
        "email": "lauren@lauren.com",
        "birthdate": "31/08/2018",
        "kind_id": 3,
        "phones_attributes":[
            {
                "id": "185",
                "_destroy", 1
            },
            {
                "id": "192"
            }
        ]
    }
}

## S1A24 - Address com has_one

# No rails console
rails g model Address street:string city:string contact:references

# Contact Model
has_one :address
accepts_nested_attributes_for :address

# Em dev.rake
    puts "Resetando BD"
    %x(rails db:drop db:create db:migrate)

## S1A26 - Rails c com has_one
O has_one pode ter mais de um dado no campo desejado onde se faz a consulta where, mas ele sempre pega um e sempre é o último.

## S1A27 - CRUD com has_one
E se eu quiser deixar criar/atualizar apenas um endereço sendo uma relação 1:1?
accepts_nested_attributes_for :address, update_only: true

## S1A28 - CORS
Cross Origin Resource Sharing
Compartilhamento de recursos de origem cruzada
Quando, por exemplo,  você entra em um site e há uma imagem que não veio carregada do mesmo servidor do site, e sim de um outro (ex. Flickr, ImageShare, etc). Isso é o CORS.

# CORS gem
https://github.com/cyu/rack-cors

# Testa requisição REST
resttesttest.com

# Em cors.rb
Descomentar a partir da linha 8 na application para permitir que a requisição seja testada

# Definição
O CORS é uma especificação de uma tecnologia de navegadores que define meios para um servidor permitir qeu seus recursos sejam acessados por uma página web de um domínio diferente.

## S2A29 - Active Model Serializers

# JSON API Specification
Como tratar o JSON quando desenvolvemos API
https://jsonapi.org

# Gem
gem 'active_model_serializers', '~> 0.10.0'

# Criando serializador para os models que vamos trabalhar
rails g serializer contact
rails g serializer kind
Que são as models que estamos trabalhando
Cria em app/serializer, que fica as representações da serialização dos elementos que precisamos

## S2A30 - i18n + json_api Adapter
Ao invés de retornar o render json que está na tela do controller, ele dá prioridade ao serializador que criamos com a gem serializer

# Data i18n
No serializer de contact
  def as_json(*args)
  h = super(*args)
  h[:birthdate] = (I18n.l(object.birthdate) unless object.birthdate.blank?)
  h

# Adaptador do JSON API Specification
Criar config/initializers/ams.rb
ActiveModel::Serializer.config.adapter = :json_api

# Data no JSON API
O JSON API Specification precisa receber a data no padrão da ISO 8601. Logo, não podemos retornar no formato brasileiro como definimos anteriormente. A ideia é que quem receba os dados manipule a data e mostre a data no formato que preferir.

# Implementando data especificada
Basta usar o .to_time.iso8601 no serializer
  def as_json(*args)
    h = super(*args)
    h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    h
  end

  ## S2A31 - Associações com AMS
  Nos serializadores
    # Associations
  belongs_to :kind, optional: true
  has_many :phones
  has_one :address

  ## S2A32 - Visualizando campos associados
# GET /contacts/1
  def show
    render json: @contact, include: [:kind]
  end

   ## S2A33 - Adicionando informações extras no JSON

   # Meta
     # GET /contacts/1
  def show
    render json: @contact, include: [:kind], meta: {author: "Lauren"}
  end

  # Adicionar para todas as chamadas
  meta do{
      author: "Lauren"
  }
  end

   ## S2A34 - Links (HATEOAS)
   Links que vão dentro da resposta (hyperlinks)
   Hypermedia As The Engine  Of Application State
   Permite que o JSON de resposta venha com um link com as opções disponíveis de ação

   ## S2A35 - AMS e links
   http://jsonapi.org/format/#document-links
   Seguir o padrão:
   "links": {
       "self": "http://example.com/posts"
   }

# No contact_serializer
    link(:self) { contact_path(object.id) }
    "links":{
        "self": "/contacts/4"
    }
    link(:kind) { kind_path(object.kind.id) }
    "links":{
        "self": "/contacts/4",
        "kind": "/kinds/5"
    }
Para usar com url, só usar contact_url ao invés de path

# Antes de usar com URL é necessário, development.rb
Rails.application.routes.default_url_options = {
    host: 'localhost',
    port: 3000
}

# relationships
Permite você relacionar esses dados do link no bloco relacionado
Se é kind, ele é agrupado junto ao kind dos relacionamentos

belongs_to :kind do
    link(:related) { kind_path(object.kind.id) }
  has_many :phones

  ## S02A36 Correçõs, ajustes e Foreman gem

  # Limpando o JSON
  Tirar os links que ficaram no final

  # Foreman Gem
  https://github.com/ddollar/foreman
 Manage Procfile-based applications
 gem 'foreman'

 Automatiza comandos e ações
 # Automatizando run
 Criar arquivo "Procfile"
 web: rails s -b b 0.0.0.0

 Executar comando
    foreman start

Se der erro com o cd, utilizar sudo gem install foreman para instalar

## S2A37 Media types
Media Type é uma string que define qual o formato do dado e como ele deve ser lido pela máquina. Isso permite um computador diferenciar entre JSON e XML, por exemplo.
É um texto que você envia ao servidor indicando qual o tipo de dado você quer como retorno.
- application/json
- application/xml
- multipart/form-data
- text/html
Para informar o media type, usamos o header field Accept no momento da requisição.

# Usando cURL
curl http://localhost:3000/contacts/4 -H "Accept: application/json" -v

MIME Type e MEdia Type são a mesma coisa

# Travando o tipo de resposta apenas quando o header Accept é json
Em application_controller.rb

before_filter :ensure_json_request

def ensure_json_request
    return if request.headers["Accept"] =~ /json/
    render :nothing => true, :status => 406
end

Antes de fazer qualquer coisa na controller, roda o método ensure_json_request
O método vai verificar se o header da requisição é /json/. Se sim, deixa a requisição seguir, senão retorna 406 (Not Acceptable).

# Para seguir o padrão de especificação
Em config/initializers/mime_types.rb

Mime::Type.register "application/vnd.api+json", :json
Renderiza o tipo json para vnd.api+json para seguir a especificação

# Permite SOMENTE vnd.api+json
Altera-se na contoller do application
return if request.headers["Accept"] =~ /vnd\.api\+json/

## S2A38 - Correção no serializer