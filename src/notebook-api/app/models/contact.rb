class Contact < ApplicationRecord
    def author
        "Lauren Ferreira"
    end

    def as_json(options={})
        super(methos: :author, root: true)
    end
end
