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
                students
            when :PRZEDMIOTY
                subjects
            when :STATYSTYKI
                statistics
            when :OCENY
                grades
            when :UWAGI
                notes
            when :DANE
                importingExporting
            when :EXIT
              exit
            end
        end
        mainmenu
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
                puts "dodawanie ucznia"
            when :EDYTUJ
                puts "edycja ucznia"
            when :USUN
                puts "usuniecie ucznia"
            when :WYSWIETL
                puts "wyswietl uczniow"
            when :POWROT
                mainmenu
            end
        end
        students
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
                puts "dodawanie przedmiotu"
            when :EDYTUJ
                puts "edycja przedmiotu"
            when :USUN
                puts "usuniecie przedmiotu"
            when :WYSWIETL
                puts "wyswietl przedmioty"
            when :POWROT
                mainmenu
            end
        end
        subjects
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
                mainmenu
            end
        end
        statistics
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
                mainmenu
            end
        end
        importingExporting
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
                mainmenu
            end
        end
        grades
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
                mainmenu
            end
        end
        notes
    end
end

Menu.mainmenu