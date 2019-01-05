require File.join($__lib__,'database','database_service')

class InvalidSourceError < StandardError
end

class InvalidTableError < StandardError
end

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
        
        if source.is_a? String
            raise StandardError, 'nie znaleziono pkiku' unless File.file? source
            f = File.open source,'r'
        end

        added = 0
        errors = []
        i = 1

        case table
        when :students #id,firstname,lastname,birthdate,student_class,student_number
            if source.is_a? String
                f.each do |line|
                    begin
                        data = line.split(';')
                        s=Student.new
                        s.id=data[0].to_i
                        s.firstname=data[1]
                        s.lastname=data[2]
                        s.birthdate=data[3]
                        s.student_class=data[4]
                        s.student_number=data[5].to_i
                        s.save
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                source.each do |data|
                    begin
                        s=Student.new
                        s.id=data[0].to_i
                        s.firstname=data[1]
                        s.lastname=data[2]
                        s.birthdate=data[3]
                        s.student_class=data[4]
                        s.student_number=data[5].to_i
                        s.save
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            else
                raise InvalidSourceError, "nieobsługiwane źródło"
            end
        when :notes #id, student_id, text, date
            if source.is_a? String
                f.each do |line|
                    begin
                        data = line.split(';')
                        n=Note.new
                        n.id=data[0].to_i
                        n.student_id=data[1].to_i
                        n.text=data[2]
                        n.date=data[3]
                        n.save
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                source.each do |data|
                    begin
                        n=Note.new
                        n.id=data[0].to_i
                        n.student_id=data[1].to_i
                        n.text=data[2]
                        n.date=data[3]
                        n.save
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            else
                raise InvalidSourceError, "nieobsługiwane źródło"
            end
        when :grades #id,student_id,subject_id,grade,date
            if source.is_a? String
                f.each do |line|
                    begin
                        data = line.split(';')
                        g=Grade.new
                        g.id=data[0].to_i
                        g.student_id=data[1].to_i
                        g.subject_id=data[2].to_i
                        g.grade=data[3]
                        g.date=data[4]
                        g.save
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            elsif source.is_a? Array and source[0].is_a? Array
                source.each do |data|
                    begin
                        g=Grade.new
                        g.id=data[0].to_i
                        g.student_id=data[1].to_i
                        g.subject_id=data[2].to_i
                        g.grade=data[3]
                        g.date=data[4]
                        g.save
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            else
                raise InvalidSourceError, "nieobsługiwane źródło"
            end
        when :subjects #id,name
            if source.is_a? String
                i = 1
                f.each do |line|
                    begin
                        data = line.split(';')
                        s = Subject.new
                        s.id=data[0].to_i
                        s.name=data[1]
                        s.save
                        added = added + 1
                    rescue
                        errors << i
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
                        added = added + 1
                    rescue
                        errors << i
                    end
                    i = i+1
                end
            else
                raise InvalidSourceError, "nieobsługiwane źródło"
            end
        else
            raise InvalidTableError, "nieobsługiwana tabela" 
        end

        if source.is_a? String
            f.close
        end

        return [added,errors]
    end

    def deploy_demo_data
        students = [
            [1,"Jan","Kowalski",'1998-01-22','3A',5],
        ]

        subjects = [
            [1,"Matematyka"],
        ]

        notes = [
            [1,1,"Sample note","2007-05-18"]
        ]

        grades = [
            [1,1,1,"3-","2010-07-09"]
        ]

        import_data :students,students
        import_data :subjects,subjects
        import_data :notes,notes
        import_data :grades,grades
    end

    def export_data table,file
        dbs = DatabaseService.new @db
        begin
            f = File.open(file,"w")
        rescue
            raise ArgumentError, '"file" nie jest nadpisywalne'
        end
        case table
        when :students #id,firstname,lastname,birthdate,student_class,student_number
            Student.each do |s|
                f.write s.id.to_s+";"+s.firstname+";"+s.lastname+";"+s.birthdate.to_s+";"+s.student_class+";"+s.student_number.to_s+"\n"
            end
        when :notes #id, student_id, text, date
            Note.each do |n|
                f.write n.id.to_s+";"+n.student_id.to_s+";"+n.text+";"+n.date.to_s+"\n"       
            end     
        when :grades #id,student_id,subject_id,grade,date
            Grade.each do |g|
                f.write g.id.to_s+";"+g.student_id.to_s+";"+g.subject_id.to_s+";"+g.grade+";"+g.date.to_s+"\n"
            end
        when :subjects #id,name
            Subject.each do |s|
                f.write s.id.to_s+";"+s.name+"\n"
            end
        else
            raise InvalidTableError, "nieobsługiwana tabela" 
        end
        f.close
    end
end