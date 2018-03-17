class Contact < ApplicationRecord
    belongs_to :kind
    
    def author
        "Lauren Ferreira"
    end

    def as_json(options={})
        super(methods: :author, root: true)
    end
end
