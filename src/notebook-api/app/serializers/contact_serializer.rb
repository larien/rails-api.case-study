class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :birthdate

  # Associations
  belongs_to :kind do
    link(:related) { kind_path(object.kind.id) }
  has_many :phones
  has_one :address

  # link(:self) { contact_path(object.id) }
  # link(:related) { kind_path(object.kind.id) }
  

  meta do
    {
      author: "Lauren"
    }
  end

  def as_json(*args)
    h = super(*args)
    # pt-BR - h[:birthdate] = (I18n.l(object.birthdate) unless object.birthdate.blank?)
    h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    h
  end
end