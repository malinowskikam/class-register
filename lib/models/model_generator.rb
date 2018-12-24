require File.join($__lib__,'errors','errors.rb')

class ModelGeneretor
    def generate_models db
        raise NoTableError, 'Brak tabeli "student" w bazie danych' unless db.table_exists? :student
        class Student < Sequel::Model(db[:student])
        end

        raise NoTableError, 'Brak tabeli "note" w bazie danych' unless db.table_exists? :note
        class Note < Sequel::Model(db[:note])
        end

        raise NoTableError, 'Brak tabeli "grade" w bazie danych' unless db.table_exists? :grade
        class Grade < Sequel::Model(db[:grade])
        end

        raise NoTableError, 'Brak tabeli "subject" w bazie danych' unless db.table_exists? :subject
        class Subject < Sequel::Model(db[:subject])
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
    end
end