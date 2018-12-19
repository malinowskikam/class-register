class Menu

    @flag

    def self.main
        @flag = true

        while @flag
            self.mainmenu
        end
    end

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

        self.clear
        puts "Wybierz opcje:"
        positions = [
            { "id" => :UCZNIOWIE, "label" => "Uczniowie" },
            { "id" => :PRZEDMIOTY, "label" => "Przedmioty" },
            { "id" => :STATYSTYKI, "label" => "Statystyki" },
            { "id" => :OCENY, "label" => "Oceny" },
            { "id" => :UWAGI, "label" => "Uwagi" },
            { "id" => :DANE, "label" => "Import/Eksport danych" },
            { "id" => :EXIT, "label" => "Zakończ" }
        ]
        self.render_positions positions
        
        puts "\nWybór:"
        option = gets.chomp
        option = option.to_i

        if option>0 and option<=positions.length

            case positions[option-1]["id"]
            when :UCZNIOWIE
                puts "funkcja która rozwija uczniów"
            when :PRZEDMIOTY
                puts "funkcja która rozwija przedmioty"
            when :STATYSTYKI
                puts "funkcja która rozwija statystyki"
            when :OCENY
                puts "funkcja która rozwija oceny"
            when :UWAGI
                puts "funkcja która rozwija uwagi"
            when :DANE
                puts "funkcja która rozwija dane"
            when :EXIT
                @flag=false
            end
            gets
        end
    end
end

Menu.main