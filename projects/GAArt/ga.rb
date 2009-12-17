require 'fox12/colors'

# === Genetic Algorithm
#
# Text below is from http://cs.felk.cvut.cz/~xobitko/ga/
#
# ==== Outline of the Basic Genetic Algorithm
#
# 1. [Start] Generate random population of n chromosomes (suitable solutions for the problem)
# 2. [Fitness] Evaluate the fitness f(x) of each chromosome x in the population
# 3. [New population] Create a new population by repeating following steps until the new population is complete
#    1. [Selection] Select two parent chromosomes from a population according to their fitness (the better fitness, the bigger chance to be selected)
#    2. [Crossover] With a crossover probability cross over the parents to form new offspring (children). If no crossover was performed, offspring is the exact copy of parents.
#    3. [Mutation] With a mutation probability mutate new offspring at each locus (position in chromosome).
#    4. [Accepting] Place new offspring in the new population 
# 4. [Replace] Use new generated population for a further run of the algorithm
# 5. [Test] If the end condition is satisfied, stop, and return the best solution in current population
# 6. [Loop] Go to step 2 
#
# ==== Crossover rate
# Crossover rate should be high generally, about 80%-95%. (However some results show that for some problems crossover rate about 60% is the best.)
# ==== Mutation rate
# On the other side, mutation rate should be very low. Best rates seems to be about 0.5%-1%.
module GA
    include Config
    include Fox

    # Breed two new children
    def crossover!(chroms)
        r = rand
        if(CrossoverProbability > r)
            c1, c2 = chroms[0], chroms[1]
            coIdx = rand(ImgWidth*ImgHeight)
            (0..coIdx).each do |idx|
                c1[idx], c2[idx] = c2[idx], c1[idx]
            end
        end
        chroms[0].crossoverIdx = chroms[1].crossoverIdx = coIdx
    end
    
    def mutate!(chrom)
        chrom.to_s
        mutCount = 0
        chrom.each_index do |idx|
            r = rand
            if(MutationProbability > r)
                mutCount += 1
                rgb = rand(255)
                chrom[idx]  = FXRGB(rgb, rgb, rgb)
            end
        end
        chrom.nofMutations = mutCount
    end

    def crossoverAndMutate!(chroms)
        crossover!(chroms)
        
        mutate!(chroms[0])
        mutate!(chroms[1])
        
    end
end