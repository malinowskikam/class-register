class Subject < Sequel::Model
    plugin :validation_helpers

    def validate #wzorujac sie na https://sequel.jeremyevans.net/rdoc/files/doc/validations_rdoc.html
        validates_presence[:Name]
        validates_unique :Name
        validates_type String, :Name
        validates_format /"^\\s+[A-Za-z,;'\"\\s]+$"/, :Name, message: 'Nazwa nie jest prawidłowa'
    end
    def createTableSubject
        db.create_table(:subject) do
            primary_key :idSubject
            String :Name
        end
    end

    def editInSubjectTableByName id, newName
        db[:subject].where(idSubject: id).update(
            :Name => newName)
    end

    def addSubject name
        db[:subject].insert(
            :Name => name
        )
    end

    def deleteSubjectByName name
        db[:subject].where(name: name).delete
    end

    def findSubjectByName name
        db[:subject].where(name: name).all
    end

    def view
        db[:subject].all
    end
end