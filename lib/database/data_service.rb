require File.join($__lib__,'database','database_service')

class DataService
    @db
    attr_reader :db

    def initialize db
        raise ArgumentError, '"db" nie jest obiektem bazy danych' unless database_valid? db
        @db=db
        raise ArgumentError, 'brak połączenia z "db"' unless connected?
    end

    def database_valid? db
        if(db!=nil and db.is_a? Sequel::Database)
            return true
        else
            return false
        end
    end

    def connected?
        begin
            @db.test_connection
        rescue
            return false
        end
        return true
    end

    def import_data table,source
        dbs = DatabaseService.new @db
        case table
        when :students #id,firstname,lastname,birthdate,student_class,student_number
            if source.is_a? String
                raise StandardError, 'nie znaleziono pkiku' unless File.file? source
                f = File.open source,'r'
                i = 1
                f.each do |line|
                    begin
                        data = line.split(';')
                        s.Student.new
                        s.id=data[0].to_i
                        s.firstname=data[1]
                        s.lastname=data[2]
                        s.birthdate=data[3]# DOPISAĆ PARSOWANIE DATY!!!!
                        s.student_class=data[4]
                        s.student_number=data[5].to_i
                        s.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                i = 1
                source.each do |data|
                    begin
                        s.Student.new
                        s.id=data[0].to_i
                        s.firstname=data[1]
                        s.lastname=data[2]
                        s.birthdate=data[3]# DOPISAĆ PARSOWANIE DATY!!!!
                        s.student_class=data[4]
                        s.student_number=data[5].to_i
                        s.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            else
                raise StandardError, "nieobsługiwane źródło"
            end
        when :notes #id, student_id, text, date
            if source.is_a? String
                raise StandardError, 'nie znaleziono pkiku' unless File.file? source
                f = File.open source,'r'
                i = 1
                f.each do |line|
                    begin
                        data = line.split(';')
                        n.Student.new
                        n.id=data[0].to_i
                        n.student_id=data[1].to_i
                        n.text=data[2]
                        n.date=data[3]# DOPISAĆ PARSOWANIE DATY!!!!
                        n.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                i = 1
                source.each do |data|
                    begin
                        n.Student.new
                        n.id=data[0].to_i
                        n.student_id=data[1].to_i
                        n.text=data[2]
                        n.date=data[3]# DOPISAĆ PARSOWANIE DATY!!!!
                        n.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            else
                raise StandardError, "nieobsługiwane źródło"
            end
        when :grades #id,student_id,subject_id,grade,weight,date
            if source.is_a? String
                raise StandardError, 'nie znaleziono pkiku' unless File.file? source
                f = File.open source,'r'
                i = 1
                f.each do |line|
                    begin
                        data = line.split(';')
                        g.Grade.new
                        g.id=data[0].to_i
                        g.student_id=data[1].to_i
                        g.subject_id=data[2].to_i
                        g.grade=data[3]
                        g.weight=data[4].to_f
                        g.date=data[5]# DOPISAĆ PARSOWANIE DATY!!!!
                        g.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                i = 1
                source.each do |data|
                    begin
                        g.Grade.new
                        g.id=data[0].to_i
                        g.student_id=data[1].to_i
                        g.subject_id=data[2].to_i
                        g.grade=data[3]
                        g.weight=data[4].to_f
                        g.date=data[5]# DOPISAĆ PARSOWANIE DATY!!!!
                        g.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            else
                raise StandardError, "nieobsługiwane źródło"
            end
        when :subjects #id,name
            if source.is_a? String
                raise StandardError, 'nie znaleziono pkiku' unless File.file? source
                f = File.open source,'r'
                i = 1
                f.each do |line|
                    begin
                        data = line.split(';')
                        s = Subject.new
                        s.id=data[0].to_i
                        s.name=data[1]
                        s.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                i = 1
                source.each do |data|
                    begin
                        s = Subject.new
                        s.id=data[0].to_i
                        s.name=data[1]
                        s.save
                    rescue
                        p "wystąpił błąd w linii: " + i.to_s
                    end
                    i = i+1
                end
            else
                raise StandardError, "nieobsługiwane źródło"
            end
        else
            raise StandardError, "nieobsługiwana tabela" 
        end
    end
end