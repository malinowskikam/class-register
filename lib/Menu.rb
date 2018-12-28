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
        dbs = DatabaseService.new Sequel.sqlite
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
                s.firstname = gets
                puts "Podaj nazwisko:"
                s.lastname = gets
                puts "Podaj dzień z daty urodzenia:"
                birth_day = gets.to_i
                puts "Podaj miesiąc z daty urodzenia:"
                birth_month = gets.to_i
                puts "Podaj rok z daty urodzenia:"
                birth_year = gets.to_i
                s.birthdate = DateTime.new(birth_year, birth_month, birth_day)
                puts "Podaj klasę, do której uczeń należy:"
                s.student_class = gets
                puts "Podaj numer w dzienniku:"
                s.student_number = gets
                if s.valid?
                    s.save
                    puts "\nUczeń został dodany do bazy!"
                else
                    puts "\nJedna z wartości była nieprawidłowa! Spróbuj ponownie."
                end
                gets
            when :EDYTUJ
                puts "edycja ucznia"
            when :USUN
                puts "usuniecie ucznia"
            when :WYSWIETL
                clear
                str = "Imię".ljust(20) + " | " + "Nazwisko".ljust(20) + " | " + "Data urodzenia".ljust(15) + " | " + "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(15)
                puts str
                puts "-------------------------------------------------------------------------------------------"
                Student.each do |student|
                    str = student.firstname[0...-1].ljust(20) + ' | ' + student.lastname[0...-1].ljust(20) + ' | ' + student.birthdate.strftime("%F").ljust(15) + ' | ' + student.student_class[0...-1].ljust(10) + ' | ' + student.student_number.to_s.ljust(15)
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
              s.name = gets
              if s.valid?
                s.save
                puts "\nPrzedmiot został zapisany do bazy!"
              else
                puts "\nPodana nazwa jest nieprawidłowa! Spróbuj ponownie."
              end
              gets
            when :EDYTUJ
                puts "edycja przedmiotu"
            when :USUN
                puts "usuniecie przedmiotu"
            when :WYSWIETL
                clear
                str = "Nazwa".ljust(30)
                puts str
                puts "------------------------------"
                Subject.each do |subject|
                    str = subject.name[0...-1].ljust(30)
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
            { "id" => :PRZEDMIOT,   "label" => "Pokaż średnią z danego przedmiotu" },
            { "id" => :UCZEN,       "label" => "Pokaż średnią podanego ucznia z przedmiotów" },
            { "id" => :POWROT,      "label" => "Powrót"}
        ]
        render_positions positions
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i
        if option>0 and option<=positions.length
            case positions[option-1]["id"]
            when :PRZEDMIOT
                puts "srednie przedmiotu"
            when :UCZEN
                puts "srednie ucznia"
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
                puts "import"
            when :EDYTUJ
                puts "eksport"
            when :USUN
                puts "usun"
            when :WYSWIETL
                puts "wyswietl"
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
                puts "dodaj"
            when :EDYTUJ
                puts "edytuj"
            when :USUN
                puts "usun"
            when :WYSWIETL
                puts "wyswietl"
            when :POWROT
                @flagNotes=false
            end
        end
    end

    def self.prepare_database
        
    end
end

Menu.main