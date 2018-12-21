require File.join($__lib__,'errors','errors.rb')

class ModelGeneretor
    def generate_models db
        raise NoTableError, 'Brak tabeli "student" w bazie danych' unless db.table_exists? :student
        class Student < Sequel::Model(db[:student])
        end

        raise NoTableError, 'Brak tabeli "note" w bazie danych' unless db.table_exists? :note
        class Note < Sequel::Model(db[:note])
        end

        raise NoTableError, 'Brak tabeli "reprimand" w bazie danych' unless db.table_exists? :reprimand
        class Reprimand < Sequel::Model(db[:reprimand])
        end

        raise NoTableError, 'Brak tabeli "subject" w bazie danych' unless db.table_exists? :subject
        class Reprimand < Sequel::Model(db[:subject])
        end
    end
end