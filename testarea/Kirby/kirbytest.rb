require 'pp'
require 'kirbybase'

def now
    Time.now.strftime("%Y-%m-%d %H:%M:%S")
end

class KBTable
    def record_exists?(col, val)
        !(self.select { |r| r.send(col) == val }).empty?
    end
end


db = KirbyBase.new(:local, nil, nil, ".")

# db.drop_table :users
if(db.table_exists?(:users))
    @users = db.get_table(:users)
    # pp @users
else
    @users = db.create_table(:users, 
    :name, {:DataType=>:String, :Index=>1},
    :created_at, :String)
end

pp @users.record_exists?(:name, 'Michelex')

# users.insert('Michele', now) unless exists?(@users, :name, 'Michele')
# users.insert('Arne', now)

# puts @users.select.to_report
