class Dog
    attr_accessor :name, :breed, :id
    
    def initialize(name: name, breed: breed, id: nil)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS dogs (
                id INTEGER PRIMARY KEY,
                name TEXT,
                album TEXT
                )
        SQL
        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = "DROP TABLE IF EXISTS dogs"
        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
        SQL

        DB[:conn].execute(sql, self.name, self.breed)
    end

    def self.create
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end

    def self.new_from_db
        self.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.all
        sql = <<-SQL
            SELECT * 
            FROM dogs
        SQL

        DB[:conn].execute(sql)
    end

    def self.find_by_name(name)
        sql = <<-SQL
            SELECT *
            FROM songs
            WHERE name = ?
            LIMIT 1
        SQL

        DB[:conn].execute(sql, name).map do |row|
            self.new_from_db(row)
          end.first
    end

    def self.find(id)
        sql = <<-SQL
        SELECT *
        FROM songs
        WHERE id = ?
        LIMIT 1
    SQL

    DB[:conn].execute(sql, id).map do |row|
        self.new_from_db(row)
      end.first
    end
end
