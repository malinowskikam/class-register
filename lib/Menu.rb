$__lib__ = File.join(__dir__,'..','lib')
require File.join($__lib__,'database','database_service')

class Menu

    #czyszczenie konsoli
    def self.clear
        Gem.win_platform? ? (system "cls") : (system "clear")
    end

    def self.render_positions positions
        i = 1

        positions.each do |position|
            puts "    " + i.to_s + " - " + position["label"]
            i = i + 1
        end
    end

    #_______________________________________________________
    # FLAGI
    @flagMenu
    @flagStudents
    @flagSubjects
    @flagStatistics
    @flagImportingExporting
    @flagGrades
    @flagNotes

    def self.main
        @flagMenu = true

        self.prepare_database

        while @flagMenu
            mainmenu
        end
    end

    def self.studentsLoop
        @flagStudents = true

        while @flagStudents
            students
        end
    end

    def self.subjectsLoop
        @flagSubjects = true

        while @flagSubjects
            subjects
        end
    end

    def self.statisticsLoop
        @flagStatistics = true

        while @flagStatistics
            statistics
        end
    end

    def self.importingExportingLoop
        @flagImportingExporting = true

        while @flagImportingExporting
            importingExporting
        end
    end

    def self.gradesLoop
        @flagGrades = true

        while @flagGrades
            grades
        end
    end

    def self.notesLoop
        @flagNotes = true

        while @flagNotes
            notes
        end
    end

    #________________________________________________________
    #OBSLUGA
    def self.mainmenu
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :UCZNIOWIE,       "label" => "Uczniowie" },
            { "id" => :PRZEDMIOTY,      "label" => "Przedmioty" },
            { "id" => :STATYSTYKI,      "label" => "Statystyki" },
            { "id" => :OCENY,           "label" => "Oceny" },
            { "id" => :UWAGI,           "label" => "Uwagi" },
            { "id" => :DANE,            "label" => "Import/Eksport danych" },
            { "id" => :EXIT,            "label" => "Zakończ" }
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :UCZNIOWIE
                studentsLoop
            when :PRZEDMIOTY
                subjectsLoop
            when :STATYSTYKI
                statisticsLoop
            when :OCENY
                gradesLoop
            when :UWAGI
                notesLoop
            when :DANE
                importingExportingLoop
            when :EXIT
                @flagMenu=false
            end
        end
    end

    def self.students
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :DODAJ,       "label" => "Dodaj ucznia" },
            { "id" => :EDYTUJ,      "label" => "Edytuj ucznia" },
            { "id" => :USUN,        "label" => "Usuń ucznia" },
            { "id" => :WYSWIETL,    "label" => "Wyświetl uczniów"},
            { "id" => :POWROT,      "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length

            case positions[option-1]["id"]
            when :DODAJ
                clear
                s = Student.new
                puts "Podaj imię:"
                s.firstname = gets.chomp
                puts "Podaj nazwisko:"
                s.lastname = gets.chomp
                puts "Podaj dzień z daty urodzenia:"
                birth_day = gets.chomp.to_i
                puts "Podaj miesiąc z daty urodzenia:"
                birth_month = gets.chomp.to_i
                puts "Podaj rok z daty urodzenia:"
                birth_year = gets.chomp.to_i
                puts "Podaj klasę, do której uczeń należy:"
                s.student_class = gets.chomp
                puts "Podaj numer w dzienniku:"
                s.student_number = gets.chomp.to_i
                s.birthdate = DateTime.new
                if s.valid? and birth_day>0 and birth_day<32 and birth_month>0 and birth_month<13 and birth_year>0 and birth_year<10000
                    s.birthdate = DateTime.new(birth_year, birth_month, birth_day)
                    s.save
                    puts "\nUczeń został dodany do bazy!"
                else
                    puts "\nJedna z wartości była nieprawidłowa! Spróbuj ponownie."
                end
                gets
            when :EDYTUJ
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        puts "Podaj wartość, którą chcesz edytować:"
                        positions = [
                            {"id" => :IMIE, "label" => "Imię"},
                            {"id" => :NAZWISKO, "label" => "Nazwisko"},
                            {"id" => :DATAURODZENIA, "label" => "Data urodzenia"},
                            {"id" => :KLASA, "label" => "Klasa"},
                            {"id" => :NUMER, "label" => "Numer w dzienniku"}
                        ]
                        render_positions positions
                        puts "\nWybór:"
                        option = gets.chomp.to_i
                        if option>0 and option<=positions.length
                            case positions[option-1]["id"]
                            when :IMIE
                                puts "Podaj nowe imię:"
                                newname = gets.chomp
                                if newname.match(/^[A-Z][A-Za-ząęółćżźśĄĘÓŚŻŹĆŁ '-]+$/)
                                    Student.where(student_class: studentclass, student_number: studentnumber).update(:firstname => newname)
                                    puts "\nNowe imię zostało zapisane!"
                                else
                                    puts "\nPodano nieprawidłowe imię! Spróbuj jeszcze raz."
                                end
                            when :NAZWISKO
                                puts "Podaj nowe nazwisko:"
                                newsurname = gets.chomp
                                if newsurname.match(/^[A-Z][A-Za-ząęółćżźśĄĘÓŚŻŹĆŁ '-]+$/)
                                    Student.where(student_class: studentclass, student_number: studentnumber).update(:lastname => newsurname)
                                    puts "\nNowe nazwisko zostało zapisane!"
                                else
                                    puts "\nPodano nieprawidłowe nazwisko! Spróbuj jeszcze raz."
                                end
                            when :DATAURODZENIA
                                puts "Podaj dzień z daty urodzenia:"
                                newday = gets.chomp
                                puts "Podaj miesiąc z daty urodzenia:"
                                newmonth = gets.chomp
                                puts "Podaj rok z daty urodzenia:"
                                newyear = gets.chomp
                                if newday.match(/^[1-3][0-9]?$/) and newday.to_i<32 and newmonth.match(/^[1-9][0-2]?$/) and newmonth.to_i<13 and newyear.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/)
                                    newdate = DateTime.new(newyear.to_i, newmonth.to_i, newday.to_i)
                                    Student.where(student_class: studentclass, student_number: studentnumber).update(:birthdate => newdate)
                                    puts "\nNowa data urodzenia została zapisana!"
                                else
                                    puts "\nPodano nieprawidłowe dane! Spróbuj jeszcze raz."
                                end
                            when :KLASA
                                puts "Podaj nową klasę ucznia:"
                                newclass = gets.chomp
                                if newclass.match(/^[1-8][A-Z]?$/)
                                    Student.where(student_class: studentclass, student_number: studentnumber).update(:student_class => newclass)
                                    puts "\nNowa klasa została zapisana!"
                                else
                                    puts "\nPodano nieprawidłową klasę! Spróbuj jeszcze raz."
                                end
                            when :NUMER
                                puts "Podaj nowy numer w dzienniku ucznia:"
                                newnumber = gets.chomp.to_i
                                if newnumber > 0
                                    Student.where(student_class: studentclass, student_number: studentnumber).update(:student_number => newnumber)
                                    puts "\nNowy numer w dzienniku został zapisany!"
                                else
                                    puts "\nPodano nieprawidłowy numer! Spróbuj jeszcze raz."
                                end
                            else
                                puts "\nPodano nieprawidłową wartość! Spróbuj ponownie."
                            end
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :USUN
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        Student.where(student_class: studentclass, student_number: studentnumber).delete
                        puts "\nPodany student został usunięty z bazy!"
                    else
                        puts "\nPodany student nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :WYSWIETL
                clear
                str = "Imię".ljust(20) + " | " + "Nazwisko".ljust(20) + " | " + "Data urodzenia".ljust(15) + " | " + "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(15)
                puts str
                puts "----------------------------------------------------------------------------------------------"
                Student.each do |student|
                    str = student.firstname.ljust(20) + ' | ' + student.lastname.ljust(20) + ' | ' + student.birthdate.strftime("%F").ljust(15) + ' | ' + student.student_class.ljust(10) + ' | ' + student.student_number.to_s.ljust(15)
                    puts str
                end
                puts "\nKliknij, aby kontynuować..."
                gets
            when :POWROT
                @flagStudents =false
            end
        end
    end

    def self.subjects
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :DODAJ,       "label" => "Dodaj przedmiot" },
            { "id" => :EDYTUJ,      "label" => "Edytuj przedmiot" },
            { "id" => :USUN,        "label" => "Usuń przedmiot" },
            { "id" => :WYSWIETL,    "label" => "Wyświetl przedmioty"},
            { "id" => :POWROT,      "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :DODAJ
              clear
              s = Subject.new
              puts "Podaj nazwę przedmiotu:"
              s.name = gets.chomp
              if s.valid?
                s.save
                puts "\nPrzedmiot został zapisany do bazy!"
              else
                puts "\nPodana nazwa jest nieprawidłowa! Spróbuj ponownie."
              end
              gets
            when :EDYTUJ
                clear
                puts "Podaj nazwę:"
                name = gets.chomp
                if name.match(/[A-ZĄĘĆŹŻŚÓŁ]-?[A-ZĄĘĆŹŻŚÓŁa-ząęćśżźół .]+/)
                    if Subject.where(name: name).count == 1
                        puts "Podaj nową nazwę:"
                        newname = gets.chomp
                        if newname.match(/[A-ZĄĘĆŹŻŚÓŁ]-?[A-ZĄĘĆŹŻŚÓŁa-ząęćśżźół .]+/)
                            Subject.where(name: name).update(:name => newname)
                            puts "\nPodany przedmiot został zapisany!"
                        else
                            puts "\nPodano nieprawidłową nazwę! Spróbuj jeszcze raz."
                        end
                    else
                        puts "\nPodany przedmiot nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :USUN
                clear
                puts "Podaj nazwę:"
                name = gets.chomp
                if name.match(/[A-ZĄĘĆŹŻŚÓŁ]-?[A-ZĄĘĆŹŻŚÓŁa-ząęćśżźół .]+/)
                    if Subject.where(name: name).count == 1
                        Subject.where(name: name).delete
                        puts "\nPodany przedmiot został usunięty!"
                    else
                        puts "\nPodany przedmiot nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :WYSWIETL
                clear
                str = "Nazwa".ljust(30)
                puts str
                puts "------------------------------"
                Subject.each do |subject|
                    str = subject.name.ljust(30)
                    puts str
                end
                puts "\nKliknij, aby kontynuować..."
                gets
            when :POWROT
                @flagSubjects=false
            end
        end
    end

    def self.statistics
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :PRZEDMIOT,       "label" => "Pokaż średnią z danego przedmiotu" },
            { "id" => :UCZEN,           "label" => "Pokaż średnią podanego ucznia z podanego przedmiotu" },
            { "id" => :SREDNIAUCZNIA,   "label" => "Podaż średnią danego ucznia"},
            { "id" => :POWROT,          "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :PRZEDMIOT
                clear
                puts "Podaj nazwę przedmiotu:"
                subject = gets.chomp
                if Subject.where(name: subject).count == 1
                    str = "Nazwa przedmiotu".ljust(30) + " | " + "Średnia".ljust(10)
                    puts str
                    puts "----------------------------------------"
                    sum = 0
                    grade_float = 0.0
                    numberofgrades = 0
                    Grade.select.where(subject: Subject.select.where(name: subject)).each do |grade|
                        case grade.grade
                        when "1"
                            grade_float = 1.0
                        when "1+"
                            grade_float = 1.3
                        when "2-"
                            grade_float = 1.6
                        when "2"
                            grade_float = 2.0
                        when "2+"
                            grade_float = 2.3
                        when "3-"
                            grade_float = 2.6
                        when "3"
                            grade_float = 3.0
                        when "3+"
                            grade_float = 3.3
                        when "4-"
                            grade_float = 3.6
                        when "4"
                            grade_float = 4.0
                        when "4+"
                            grade_float = 4.3
                        when "5-"
                            grade_float = 4.6
                        when "5"
                            grade_float = 5.0
                        when "5+"
                            grade_float = 5.3
                        when "6-"
                            grade_float = 5.6
                        when "6"
                            grade_float = 6.0
                        end
                        sum = sum + grade_float
                        numberofgrades = numberofgrades + 1
                    end
                    if numberofgrades != 0
                        puts subject.ljust(30) + " | " + (sum/numberofgrades).to_f.round(2).to_s.ljust(10)
                        puts "\nKliknij, aby kontynuować..."
                    else
                        puts subject.ljust(30) + " | " + (0).to_f.to_s.ljust(10)
                        puts "\nKliknij, aby kontynuować..."
                    end
                else
                    puts "\nPodany przedmiot nie istnieje w bazie danych!"
                end
                gets
            when :UCZEN
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        puts "Podaj nazwę przedmiotu:"
                        subjectname = gets.chomp
                        if Subject.where(name: subjectname).count == 1
                            str = "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(20) + " | " + "Nazwa przedmiotu".ljust(30) + " | " + "Średnia".ljust(10)
                            puts str
                            puts "----------------------------------------------------------------------------"
                            sum = 0
                            grade_float = 0.0
                            numberofgrades = 0
                            Grade.select.where(subject: Subject.select.where(name: subjectname)).each do |grade|
                                case grade.grade
                                when "1"
                                    grade_float = 1.0
                                when "1+"
                                    grade_float = 1.3
                                when "2-"
                                    grade_float = 1.6
                                when "2"
                                    grade_float = 2.0
                                when "2+"
                                    grade_float = 2.3
                                when "3-"
                                    grade_float = 2.6
                                when "3"
                                    grade_float = 3.0
                                when "3+"
                                    grade_float = 3.3
                                when "4-"
                                    grade_float = 3.6
                                when "4"
                                    grade_float = 4.0
                                when "4+"
                                    grade_float = 4.3
                                when "5-"
                                    grade_float = 4.6
                                when "5"
                                    grade_float = 5.0
                                when "5+"
                                    grade_float = 5.3
                                when "6-"
                                    grade_float = 5.6
                                when "6"
                                    grade_float = 6.0
                                end
                                sum = sum + grade_float
                                numberofgrades = numberofgrades + 1
                            end
                            if numberofgrades == 0
                                puts studentclass.ljust(10) + " | " + studentnumber.to_s.ljust(20) + " | " + subjectname.ljust(30) + " | " + (0).to_f.to_s.ljust(10)
                                puts "\nKliknij, aby kontynuować..."
                            else
                                puts studentclass.ljust(10) + " | " + studentnumber.to_s.ljust(20) + " | " +  subjectname.ljust(30) + " | " + (sum/numberofgrades).to_f.round(2).to_s.ljust(10)
                                puts "\nKliknij, aby kontynuować..."
                            end
                        else
                            puts "\nPodany przedmiot nie istnieje w bazie danych! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych! Spróbuj ponownie."
                    end
                else
                    puts "Podane dane są nieprawidłowe! Spróbuj ponownie."
                end
                gets
            when :SREDNIAUCZNIA
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        str = "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(20) + " | " + "Nazwa przedmiotu".ljust(30) + " | " + "Średnia".ljust(10)
                        puts str
                        puts "----------------------------------------------------------------------------"
                        grade_sum= Array.new
                        grade_amount = Array.new
                        grade_name = Subject.map{|x| x.name}
                        i = 0
                        grade_name.each do |gradename|
                            grade_sum[i] = 0.0
                            grade_amount[i] = 0
                            Grade.select.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber), subject: Subject.select.where(name: gradename)).each do |grade|
                                case grade.grade
                                when "1"
                                    grade_float = 1.0
                                when "1+"
                                    grade_float = 1.3
                                when "2-"
                                    grade_float = 1.6
                                when "2"
                                    grade_float = 2.0
                                when "2+"
                                    grade_float = 2.3
                                when "3-"
                                    grade_float = 2.6
                                when "3"
                                    grade_float = 3.0
                                when "3+"
                                    grade_float = 3.3
                                when "4-"
                                    grade_float = 3.6
                                when "4"
                                    grade_float = 4.0
                                when "4+"
                                    grade_float = 4.3
                                when "5-"
                                    grade_float = 4.6
                                when "5"
                                    grade_float = 5.0
                                when "5+"
                                    grade_float = 5.3
                                when "6-"
                                    grade_float = 5.6
                                when "6"
                                    grade_float = 6.0
                                end
                                grade_sum[i] = grade_sum[i].to_f + grade_float
                                grade_amount[i] = grade_amount[i] + 1
                            end
                            i = i+1
                        end
                        i=0
                        grade_name.each do |gradename|
                            if grade_amount[i] != 0
                                puts studentclass.ljust(10) + " | " + studentnumber.to_s.ljust(20) + " | " + gradename.ljust(30) + " | " + (grade_sum[i]/grade_amount[i]).to_f.round(2).to_s.ljust(10)
                            else
                                puts studentclass.ljust(10) + " | " + studentnumber.to_s.ljust(20) + " | " + gradename.ljust(30) + " | " + (0).to_f.to_s.ljust(10)
                            end
                            i = i+1
                        end
                        puts "\nKliknij, aby kontynuować..."
                    else
                        puts "\nPodany student nie istnieje w bazie danych! Spróbuj ponownie."
                    end
                else
                    puts "\nPodane dane są nieprawidłowe! Spróbuj ponownie."
                end
                gets
            when :POWROT
                @flagStatistics=false
            end
        end
    end

    def self.importingExporting
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :IMPORT,      "label" => "Importuj dane z pliku" },
            { "id" => :EKSPORT,     "label" => "Eksportuj dane do pliku" },
            { "id" => :POWROT,      "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :IMPORT
                puts "import"
            when :EKSPORT
                puts "eksport"
            when :POWROT
                @flagImportingExporting=false
            end
        end
    end

    def self.grades
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :DODAJ,       "label" => "Dodaj ocenę" },
            { "id" => :EDYTUJ,      "label" => "Edytuj ocenę" },
            { "id" => :USUN,        "label" => "Usuń ocenę" },
            { "id" => :WYSWIETL,    "label" => "Wyświetl oceny ucznia"},
            { "id" => :POWROT,      "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :DODAJ
                clear
                g = Grade.new
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        g.student = Student.select.where(student_class: studentclass, student_number: studentnumber).first
                        puts "Podaj nazwę przedmiotu:"
                        subjectname = gets.chomp
                        if Subject.where(name: subjectname).count == 1
                            g.subject = Subject.select.where(name: subjectname).first
                            puts "Podaj ocenę:"
                            g.grade = gets.chomp
                            puts "Podaj dzień:"
                            day = gets.chomp
                            puts "Podaj miesiąc:"
                            month = gets.chomp
                            puts "Podaj rok:"
                            year = gets.chomp
                            g.date = DateTime.new
                            if g.valid? and day.to_i>0 and day.to_i<32 and month.to_i>0 and month.to_i<13 and year.to_i>0 and year.to_i<10000
                                g.date = DateTime.new(year.to_i, month.to_i, day.to_i)
                                g.save
                                puts "\nPodana ocena została zapisana!"
                            else
                                puts "\nPodane dane są nieprawidłowe! Spróbuj ponownie."
                            end
                        else
                            puts "\nPodany przedmiot nie istnieje w bazie! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :EDYTUJ
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        puts "Podaj przedmiot:"
                        subject = gets.chomp
                        if Subject.where(name: subject).count == 1
                            puts "Podaj ocenę:"
                            grade = gets.chomp
                            if grade.match(/^[1-6][+-]?$/)
                                puts "Podaj dzień:"
                                day = gets.chomp
                                puts "Podaj miesiąc:"
                                month = gets.chomp
                                puts "Podaj rok:"
                                year = gets.chomp
                                if day.match(/^[1-3][0-9]?$/) and day.to_i<32 and month.match(/^[1-9][0-2]?$/) and month.to_i<13 and year.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/) and year.to_i<10000
                                    puts "Podaj wartość, którą chcesz edytować:"
                                    positions = [
                                        {"id" => :OCENA, "label" => "Ocena"},
                                        {"id" => :DATA, "label" => "Data"}
                                    ]
                                    render_positions positions
                                    puts "\nWybór:"
                                    option = gets.chomp.to_i
                                    if option>0 and option<=positions.length
                                        case positions[option-1]["id"]
                                        when :OCENA
                                            puts "Podaj nową ocenę:"
                                            newgrade = gets.chomp
                                            if newgrade.match(/^[1-6][+-]?$/)
                                                if Grade.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                               subject: Subject.select.where(name: subject),
                                                               grade: grade,
                                                               date: DateTime.new(year.to_i, month.to_i, day.to_i)).count == 1
                                                    Grade.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                                subject: Subject.select.where(name: subject),
                                                                grade: grade,
                                                                date: DateTime.new(year.to_i, month.to_i, day.to_i)).update(:grade => newgrade)
                                                    puts "\nNowa ocena została zapisana!"
                                                else
                                                    puts "\nPodana ocena nie istnieje w bazie danych!"
                                                end
                                            else
                                                puts "\nPodano nieprawidłową ocenę! Spróbuj jeszcze raz."
                                            end
                                        when :DATA
                                            puts "Podaj dzień:"
                                            newday = gets.chomp
                                            puts "Podaj miesiąc:"
                                            newmonth = gets.chomp
                                            puts "Podaj rok:"
                                            newyear = gets.chomp
                                            if newday.match(/^[1-3][0-9]?$/) and newday.to_i<32 and newmonth.match(/^[1-9][0-2]?$/) and newmonth.to_i<13 and newyear.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/) and newyear.to_i<10000
                                                if Grade.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                               subject: Subject.select.where(name: subject),
                                                               grade: grade,
                                                               date: DateTime.new(year.to_i, month.to_i, day.to_i)).count == 1
                                                    Grade.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                                subject: Subject.select.where(name: subject),
                                                                grade: grade,
                                                                date: DateTime.new(year.to_i, month.to_i, day.to_i)).update(:date => DateTime.new(newyear.to_i, newmonth.to_i, newday.to_i))
                                                    puts "\nNowa data została zapisana!"
                                                else
                                                    puts "\nPodana ocena nie istnieje w bazie danych!"
                                                end
                                            else
                                                puts "\nPodano nieprawidłowe dane! Spróbuj jeszcze raz."
                                            end
                                        end
                                    end
                                else
                                    puts "\nPodałeś nieprawidłową datę! Spróbuj ponownie."
                                end
                            else
                                puts "\nPodałeś nieprawidłową ocenę! Spróbuj ponownie."
                            end
                        else
                            puts "\nPodany przedmiot nie istnieje w bazie danych! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych! Spróbuj ponownie."
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :USUN
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        puts "Podaj przedmiot:"
                        subject = gets.chomp
                        if Subject.where(name: subject).count == 1
                            puts "Podaj ocenę:"
                            grade = gets.chomp
                            if grade.match(/^[1-6][+-]?$/)
                                puts "Podaj dzień:"
                                day = gets.chomp
                                puts "Podaj miesiąc:"
                                month = gets.chomp
                                puts "Podaj rok:"
                                year = gets.chomp
                                if day.match(/^[1-3][0-9]?$/) and day.to_i<32 and month.match(/^[1-9][0-2]?$/) and month.to_i<13 and year.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/) and year.to_i<10000
                                    if Grade.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                   subject: Subject.select.where(name: subject),
                                                   grade: grade,
                                                   date: DateTime.new(year.to_i, month.to_i, day.to_i)).count == 1
                                        Grade.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                    subject: Subject.select.where(name: subject),
                                                    grade: grade,
                                                    date: DateTime.new(year.to_i, month.to_i, day.to_i)).delete
                                        puts "\nPodana ocena została usunięta z bazy!"
                                    else
                                        puts "\nPodana ocena nie istnieje w bazie danych!"
                                    end
                                else
                                    puts "\nPodałeś nieprawidłową datę! Spróbuj ponownie."
                                end
                            else
                                puts "\nPodałeś nieprawidłową ocenę! Spróbuj ponownie."
                            end
                        else
                            puts "\nPodany przedmiot nie istnieje w bazie danych! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych! Spróbuj ponownie."
                    end
                else
                    puts "\nPodałeś nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :WYSWIETL
              clear
              puts "Podaj klasę:"
              studentclass = gets.chomp
              puts "Podaj numer w dzienniku:"
              studentnumber = gets.chomp.to_i
              if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                  if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                    str = "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(20) + " | " + "Przedmiot".ljust(30) + " | " + "Ocena".ljust(10) + " | " + "Data wystawienia".ljust(15)
                    puts str
                    puts "---------------------------------------------------------------------------------------------------------------"
                    Grade.all.each do |grade|
                        str = grade.student.student_class.ljust(10) +
                            " | " + grade.student.student_number.to_s.ljust(20) +
                            " | " + grade.subject.name.ljust(30) +
                            " | " + grade.grade.ljust(10) +
                            " | " + grade.date.strftime("%F").ljust(15)
                        puts str
                    end
                    puts "\nKliknij, aby kontynuować..."
                  else
                      puts "Podany student nie istnieje w bazie danych! Spróbuj ponownie."
                  end
              else
                  puts "Podano nieprawidłowe dane! Spróbuj ponownie."
              end
              gets
            when :POWROT
                @flagGrades=false
            end
        end
    end

    def self.notes
        clear
        puts "Wybierz opcję:"
        positions = [
            { "id" => :DODAJ,       "label" => "Dodaj uwagę" },
            { "id" => :EDYTUJ,      "label" => "Edytuj uwagę" },
            { "id" => :USUN,        "label" => "Usuń uwagę" },
            { "id" => :WYSWIETL,    "label" => "Wyświetl uwagi ucznia"},
            { "id" => :POWROT,      "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :DODAJ
                clear
                n = Note.new
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        n.student = Student.select.where(student_class: studentclass, student_number: studentnumber).first
                        puts "Podaj dzień:"
                        day = gets.chomp
                        puts "Podaj miesiąc:"
                        month = gets.chomp
                        puts "Podaj rok:"
                        year = gets.chomp
                        n.date = DateTime.new
                        n.text = "test" #do przechodzenia walidacji
                        if n.valid? and day.to_i>0 and day.to_i<32 and month.to_i>0 and month.to_i<13 and year.to_i>0 and year.to_i<10000
                            n.date = DateTime.new(year.to_i, month.to_i, day.to_i)
                            puts "Podaj treść uwagi:"
                            sometext = gets
                            n.text = sometext[0...-1] #dodanie do bazy bez \n na końcu
                            if n.valid?
                                n.save
                                puts "\nPodana uwaga została zapisana!"
                            else
                                puts "\nWpisana uwaga jest za krótka! Spróbuj ponownie."
                            end
                        else
                            puts "\nPodane dane są nieprawidłowe! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodano nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :EDYTUJ
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        puts "Podaj dzień:"
                        day = gets.chomp
                        puts "Podaj miesiąc:"
                        month = gets.chomp
                        puts "Podaj rok:"
                        year = gets.chomp
                        if day.match(/^[1-3][0-9]?$/) and day.to_i<32 and month.match(/^[1-9][0-2]?$/) and month.to_i<13 and year.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/) and year.to_i<10000
                            puts "Podaj wartość, którą chcesz edytować:"
                            positions = [
                                {"id" => :TRESC, "label" => "Treść"},
                                {"id" => :DATA, "label" => "Data"}
                            ]
                            render_positions positions
                            puts "\nWybór:"
                            option = gets.chomp.to_i
                            if option>0 and option<=positions.length
                                case positions[option-1]["id"]
                                when :TRESC
                                    puts "Podaj nową treść uwagi:"
                                    newnote = gets
                                    newnote = newnote[0...-1]
                                    if newnote.length>3
                                        if Note.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                      date: DateTime.new(year.to_i, month.to_i, day.to_i)).count == 1
                                            Note.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                       date: DateTime.new(year.to_i, month.to_i, day.to_i)).update(:text => newnote)
                                            puts "\nNowa treść została zapisana!"
                                        else
                                            puts "\nPodana uwaga nie istnieje w bazie danych!"
                                        end
                                    else
                                        puts "\nPodana uwaga jest za krótka! Spróbuj ponownie."
                                    end
                                when :DATA
                                    puts "Podaj dzień:"
                                    newday = gets.chomp
                                    puts "Podaj miesiąc:"
                                    newmonth = gets.chomp
                                    puts "Podaj rok:"
                                    newyear = gets.chomp
                                    if newday.match(/^[1-3][0-9]?$/) and newday.to_i<32 and newmonth.match(/^[1-9][0-2]?$/) and newmonth.to_i<13 and newyear.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/) and newyear.to_i<10000
                                        if Note.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                      date: DateTime.new(year.to_i, month.to_i, day.to_i)).count == 1
                                            Note.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                                       date: DateTime.new(year.to_i, month.to_i, day.to_i)).update(:date => DateTime.new(newyear.to_i, newmonth.to_i, newday.to_i))
                                            puts "\nNowa data została zapisana!"
                                        else
                                            puts "\nPodana uwaga nie istnieje w bazie danych!"
                                        end
                                    else
                                        puts "\nPodano nieprawidłowe dane! Spróbuj jeszcze raz."
                                    end
                                end
                            end
                        else
                            puts "\nPodano nieprawidłową datę! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych! Spróbuj ponownie."
                    end
                else
                    puts "\nPodano nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :USUN
                clear
                puts "Podaj klasę:"
                studentclass = gets.chomp
                puts "Podaj numer w dzienniku:"
                studentnumber = gets.chomp.to_i
                if studentclass.match(/^[1-8][A-Z]?$/) and studentnumber>0
                    if Student.where(student_class: studentclass, student_number: studentnumber).count == 1
                        puts "Podaj dzień:"
                        day = gets.chomp
                        puts "Podaj miesiąc:"
                        month = gets.chomp
                        puts "Podaj rok:"
                        year = gets.chomp
                        if day.match(/^[1-3][0-9]?$/) and day.to_i<32 and month.match(/^[1-9][0-2]?$/) and month.to_i<13 and year.match(/^[1-9][0-9]?[0-9]?[0-9]?[0-9]?/) and year.to_i<10000
                            if Note.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                          date: DateTime.new(year.to_i, month.to_i, day.to_i)).count == 1
                                Note.where(student: Student.select.where(student_class: studentclass, student_number: studentnumber).first,
                                           date: DateTime.new(year.to_i, month.to_i, day.to_i)).delete
                                puts "\nNowa data została usunięta!"
                            else
                                puts "\nPodana uwaga nie istnieje w bazie danych!"
                            end
                        else
                            puts "\nPodane dane są nieprawidłowe! Spróbuj ponownie."
                        end
                    else
                        puts "\nPodany student nie istnieje w bazie danych!"
                    end
                else
                    puts "\nPodano nieprawidłowe dane! Spróbuj ponownie."
                end
                gets
            when :WYSWIETL
                clear
                str = "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(20) + " | " + "Data wystawienia".ljust(17) + " | " + "Treść".ljust(60)
                puts str
                puts "---------------------------------------------------------------------------------------------------------------"
                Note.all.each do |note|
                    str = note.student.student_class.ljust(10) +
                        " | " + note.student.student_number.to_s.ljust(20) +
                        " | " + note.date.strftime("%F").ljust(17) +
                        " | " + note.text.ljust(60)
                    puts str
                end
                puts "\nKliknij, aby kontynuować..."
                gets
            when :POWROT
                @flagNotes=false
            end
        end
    end

    def self.prepare_database
        dbs = DatabaseService.new Sequel.sqlite
    end
end

Menu.main