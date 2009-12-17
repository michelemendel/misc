require 'pp'
require 'lib'


# fly { |i| [(i-1)%4 + 1, i%4 + 1] }

# id1 = [1,1,1,2,3,2,1,1]
# id2 = [2,3,4,4,4,4,4,3]
# id1 = [1,1,1,1]
# id2 = [2,3,4,3]
# id1 = [1,2,3,4]
# id2 = [2,3,4,1]
# id1 = [1,3,4,2]
# id2 = [2,4,1,3]
# id1 = [1,2,3,4,1,2]
# id2 = [2,3,4,1,3,4]
# id1 = [1,3,1,2,1,2]
# id2 = [2,4,4,3,3,4]
# i = (i-1)%id1.size

test = false
fly(test) do |i|
    # p = [[1,2],[2,3],[3,4],[4,1],[1,3],[2,4]] #square + diagonals, 720 possibilities

    id1 = [1,3,1,2,1,2]
    id2 = [2,4,4,3,3,4]
    
    idx = (i-1)%id1.size
    puts "#{i}: #{id1[idx]},#{id2[idx]}" if test
    [id1[idx], id2[idx]]
end

