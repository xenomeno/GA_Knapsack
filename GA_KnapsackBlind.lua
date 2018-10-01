dofile("Bitmap.lua")
dofile("Graphics.lua")
dofile("GA_Common.lua")

local CROSSOVER_RATE        = 0.6
local DIPLOID               = true                  -- 1 dominates 0 in case of bi-alelic
local TRIALELIC             = DIPLOID and true     -- -1,0,1 with 1 as dominant 1 and -1 as recesive 1
local IMAGE_WIDTH           = 1280
local IMAGE_HEIGHT          = 720

-- recalculatable and depending on other params in knapsack description
local CHROMOSOME_LENGTH     = false     -- this will be the number of items in the 0-1 knapsack
local MUTATION_RATE         = false     -- this will be set inverse of the CHROMOSOME_LENGTH
local WEIGHTS               = false
local MAX_WEIGHT            = false     -- it will change periodically since we are solving non stationary knapsack

local s_Knapsacks =
{
  {
    title = "Blind Non-Stationary 0-1 Knapsack: Simple",
    Weights = { 25, 95 },
    WeightsPeriod = 25,
    ItemWeights = { 12, 3, 17, 5, 40, 43, 27, 80, 11 },
    max_filename = "Knapsack/Knapsack1_Max",
    avg_filename = "Knapsack/Knapsack1_Avg",
    pop_size = 30,
    max_gens = 400,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: First 15 Natural Numbers",
    Weights = { 50, 100 },
    WeightsPeriod = 25,
    ItemWeights = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },    -- max sum 120
    max_filename = "Knapsack/Knapsack2_Max",
    avg_filename = "Knapsack/Knapsack2_Avg",
    pop_size = 30,
    max_gens = 400,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: Small-Big Primes over 100 Ones",
    Weights = { 17, 89 },
    WeightsPeriod = 100,
    ItemWeights =
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    },
    max_filename = "Knapsack/Knapsack3_Max",
    avg_filename = "Knapsack/Knapsack3_Avg",
    pop_size = 50,
    max_gens = 1000,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: 2 Big Primes over 100 Ones",
    Weights = { 83, 97 },
    WeightsPeriod = 50,
    ItemWeights =
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    },
    max_filename = "Knapsack/Knapsack4_Max",
    avg_filename = "Knapsack/Knapsack4_Avg",
    pop_size = 100,
    max_gens = 1000,
  },  
  {
    title = "Blind Non-Stationary 0-1 Knapsack: 2 Small Primes over 100 Ones",
    Weights = { 7, 19 },
    WeightsPeriod = 50,
    ItemWeights =
    {
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    },
    max_filename = "Knapsack/Knapsack5_Max",
    avg_filename = "Knapsack/Knapsack5_Avg",
    pop_size = 100,
    max_gens = 1000,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: Small-Big Primes over 20 Ones",
    Weights = { 3, 19 },
    WeightsPeriod = 50,
    ItemWeights = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    max_filename = "Knapsack/Knapsack6_Max",
    avg_filename = "Knapsack/Knapsack6_Avg",
    pop_size = 100,
    max_gens = 1000,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: 2 Big Primes over 20 Ones",
    Weights = { 13, 19 },
    WeightsPeriod = 50,
    ItemWeights = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    max_filename = "Knapsack/Knapsack7_Max",
    avg_filename = "Knapsack/Knapsack7_Avg",
    pop_size = 100,
    max_gens = 1000,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: 2 Small Primes over 20 Ones",
    Weights = { 3, 5 },
    WeightsPeriod = 50,
    ItemWeights = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    max_filename = "Knapsack/Knapsack8_Max",
    avg_filename = "Knapsack/Knapsack8_Avg",
    pop_size = 100,
    max_gens = 1000,
  },
  {
    title = "Blind Non-Stationary 0-1 Knapsack: Small-Big Primes over 20 First Naturals",
    Weights = { 23, 93 },
    WeightsPeriod = 50,
    ItemWeights = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
    max_filename = "Knapsack/Knapsack9_Max",
    avg_filename = "Knapsack/Knapsack9_Avg",
    pop_size = 100,
    max_gens = 2000,
  },
}

local function abs(a, b) return (a < 0) and -a or a end
local function Min(a, b) return (not a or b < a) and b or a end
local function Max(a, b) return (not a or b > a) and b or a end

function table.copy(t, deep, filter)
	if type(t) ~= "table" then
		assert(false, "Attept to table.copy a var of type " .. type(t))
		return {}
	end	

	if type(deep) == "number" then
		deep = deep > 1 and deep - 1
	end
	
	local meta = getmetatable(t)
	if meta then
		local __copy = rawget(meta, "__copy")
		if __copy then
			return __copy(t)
		elseif type(t.class) == "string" then
			assert(false, "Attept to table.copy an object of class " .. t.class)
			return {}
		end
	end
	local copy = {}
	for k, v in pairs(t) do
		if deep then
			if type(k) == "table" then k = table.copy(k, deep) end
			if type(v) == "table" then v = table.copy(v, deep) end
		end
		if not filter or filter(k, v) then
			copy[k] = v
		end
	end
	return copy
end

function table.find(array, field, value)
	if not array then return end
	if value == nil then
		value = field
		for i = 1, #array do
			if value == array[i] then return i end
		end
	else
		for i = 1, #array do
			if value == array[i][field] then return i end
		end
	end
end

function table.find_entry(array, field, value)
  local i = table.find(array, field, value)
  return i and array[i]
end

local function GenRndChrom(len)
  local bits = {}
  if TRIALELIC then
    for i = 1, len do
      local rnd = math.random()
      bits[i] = (rnd < 0.25) and -1 or ((rnd < 0.75) and 0 or 1)
    end
  else
    for i = 1, len do
      bits[i] = FlipCoin(0.5) and "1" or "0"
    end
    bits = table.concat(bits, "")
  end
  
  return bits
end

local function EvalChrom(chrom, list)
  local weight = 0
  local pos, len = 1, chrom.bits
  for _, word in ipairs(chrom) do
    local bits = Min(len, GetBitstringWordSize())
    local mask = 1
    for bit = 1, bits do
      if (word & mask) == mask then
        weight = weight + WEIGHTS[pos]
        if list then
          table.insert(list, WEIGHTS[pos])
        end
      end
      pos = pos + 1
      mask = mask * 2
    end
    len = len - bits
  end
  
  return ((weight > MAX_WEIGHT) and (1 / weight) or weight), list
end

local function EvalWeightsList(chrom)
  local list = {}
  _, list = EvalChrom(chrom, list)
  
  return list
end

local function GenInitPop(size, chrom_len)
  local pop = { crossovers = 0, mutations = 0 }
  while #pop < size do
    local bitstring = GenRndChrom(chrom_len)
    local chrom_words = TRIALELIC and bitstring or PackBitstring(bitstring)
    local ind = { chrom = chrom_words, fitness = 0.0 }
    if DIPLOID then
      local bitstring2 = GenRndChrom(chrom_len)
      local chrom2_words = TRIALELIC and bitstring2 or PackBitstring(bitstring2)
      ind.chrom2 = chrom2_words
    end
    table.insert(pop, ind)
  end
  
  return pop
end

local function GetExprChromBi(ind)
  local words1, words2 = ind.chrom, ind.chrom2
  local len = words1.bits
  local words = { bits = len }
  for idx, word1 in ipairs(words1) do
    local word2 = words2[idx]
    local bits = Min(len, GetBitstringWordSize())
    local word, mask = 0, 1
    for bit = 1, bits do
      if (word1 & mask) ~= 0 or (word2 & mask) ~= 0 then
        word = word + mask
      end
      mask = mask * 2
    end
    len = len - bits
    words[idx] = word
  end
  
  return words
end

local function GetExprChromTri(ind)
  local chrom1, chrom2 = ind.chrom, ind.chrom2
  local bitstring = {}
  for bit = 1, #chrom1 do
    bitstring[bit] = tostring((chrom1[bit] >= chrom2[bit]) and abs(chrom1[bit]) or abs(chrom2[bit]))
  end
  
  return PackBitstring(table.concat(bitstring, ""))
end

local function GetExprChrom(ind)
  return TRIALELIC and GetExprChromTri(ind) or GetExprChromBi(ind)
end

local function EvalPop(pop)
  local tot_fitness, min_fitness, max_fitness = 0.0
  for _, ind in ipairs(pop) do
    local chrom = DIPLOID and GetExprChrom(ind) or ind.chrom
    local fitness = EvalChrom(chrom)
    min_fitness = Min(min_fitness, fitness)
    max_fitness = Max(max_fitness, fitness)
    ind.fitness = fitness
    ind.part_tot_fitness = tot_fitness
    tot_fitness = tot_fitness + fitness
  end  
  pop[0] = { fitness = 0.0, part_tot_fitness = 0.0 }
  pop.tot_fitness = tot_fitness
  pop.avg_fitness = tot_fitness / #pop
  pop.min_fitness, pop.max_fitness = min_fitness, max_fitness
end

local function PlotPop(pop, funcs, gen)
  funcs["Min"][gen] = { x = gen, y = pop.min_fitness }
  funcs["Max"][gen] = { x = gen, y = pop.max_fitness }
  funcs["Avg"][gen] = { x = gen, y = pop.avg_fitness }
end

local function SelRW(pop)
  local slot = math.random() * pop.tot_fitness
  if slot <= 0 then
    return 1
  elseif slot >= pop.tot_fitness then
    return #pop
  end
  
  local left, right = 1, #pop
  while left + 1 < right do
    local middle = (left + right) // 2
    local part_tot = pop[middle].part_tot_fitness
    if slot == part_tot then
      return middle
    elseif slot < part_tot then
      right = middle
    else
      left = middle
    end
  end
  
  return (slot < pop[left].part_tot_fitness + pop[left].fitness) and left or right
end

local function GametoGenesis(off)
  if FlipCoin(CROSSOVER_RATE) then
    local xsite = math.random(1, CHROMOSOME_LENGTH)
    if TRIALELIC then
      for bit = xsite, #off.chrom do
        off.chrom[bit], off.chrom2[bit] = off.chrom2[bit], off.chrom[bit]
      end
    else
      ExchangeTailBits(off.chrom, off.chrom2, xsite)
    end
    
    return 1
  end
  
  return 0
end

local function Crossover(mate1, mate2)
  local off1 = { chrom = TRIALELIC and table.copy(mate1.chrom) or CopyBitstring(mate1.chrom) }
  local off2 = { chrom = TRIALELIC and table.copy(mate2.chrom) or CopyBitstring(mate2.chrom) }
  if DIPLOID then
    off1.chrom2 = TRIALELIC and table.copy(mate1.chrom2) or CopyBitstring(mate1.chrom2)
    off2.chrom2 = TRIALELIC and table.copy(mate2.chrom2) or CopyBitstring(mate2.chrom2)
  end
  
  local crossovers = 0
  if DIPLOID then
    crossovers = crossovers + GametoGenesis(off1)
    crossovers = crossovers + GametoGenesis(off2)
    local temp1, temp2 = {}, {}
    if FlipCoin(0.5) then
      temp1.chrom, temp1.chrom2 = off1.chrom, off2.chrom
      temp2.chrom, temp2.chrom2 = off1.chrom2, off2.chrom2
    else
      temp1.chrom, temp1.chrom2 = off1.chrom, off2.chrom2
      temp2.chrom, temp2.chrom2 = off1.chrom2, off2.chrom
    end
    off1, off2 = temp1, temp2
  else
    if FlipCoin(CROSSOVER_RATE) then
      local xsite = math.random(1, CHROMOSOME_LENGTH)
      ExchangeTailBits(off1.chrom, off2.chrom, xsite)
      crossovers = crossovers + 1
    end
  end
  
  return off1, off2, crossovers
end

local function MutateBitBi(chrom, word_idx, power2)
  if FlipCoin(MUTATION_RATE) then
    local word = chrom[word_idx]
    local allele = word & power2
    chrom[word_idx] = (allele ~= 0) and (word - power2) or (word + power2)
    return 1
  end
  
  return 0
end

local function MutateBi(off)
  local muts = 0
  
  local word_idx, bit_pos, power2 = 1, 1, 1
  for bit = 1, off.chrom.bits do
    muts = muts + MutateBitBi(off.chrom, word_idx, power2)
    if DIPLOID then
      muts = muts + MutateBitBi(off.chrom2, word_idx, power2)
    end
    bit_pos = bit_pos + 1
    power2 = power2 * 2
    if bit_pos > GetBitstringWordSize() then
      word_idx = word_idx + 1
      bit_pos, power2 = 1, 1
    end
  end
  
  return muts
end

local function MutateBitTri(alele)
  alele = alele + math.random(1, 2)
  return (alele > 1) and (alele - 3) or alele    -- map to -1..1
end

local function MutateTri(off)
  local chrom1, chrom2 = off.chrom, off.chrom2
  local muts = 0
  for bit = 1, #off.chrom do
    if FlipCoin(MUTATION_RATE) then
      chrom1[bit] = MutateBitTri(chrom1[bit])
      muts = muts + 1
    end
    if FlipCoin(MUTATION_RATE) then
      chrom2[bit] = MutateBitTri(chrom2[bit])
      muts = muts + 1
    end
  end
  
  return muts
end

local function Mutate(off)
  return TRIALELIC and MutateTri(off) or MutateBi(off)
end

local function DrawGraph(filename, stats, name, w1, w2, max_gens, title_text, time_text, info, info2, info3)
  filename = string.format("%s%s%s.bmp", filename, DIPLOID and "_DIPLOID" or "", DIPLOID and (TRIALELIC and "_TRIALELIC" or "_BIALELIC") or "_HAPLOID")
  print(string.format("Writing '%s'...", filename))
  local graph = { funcs = {}, name_x = stats.name_x, name_y = stats.name_y }
  graph.funcs[name] = stats.funcs[name]
  graph.funcs[string.format(" W1=%d", w1)] = { {x = 0, y = w1}, {x = max_gens, y = w1}, color = {128, 128, 128} }
  graph.funcs[string.format(" W2=%d", w2)] = { {x = 0, y = w2}, {x = max_gens, y = w2}, color = {128, 128, 128} }
  local bmp = Bitmap.new(IMAGE_WIDTH, IMAGE_HEIGHT, {0, 0, 0})
  DrawGraphs(bmp, graph, nil, nil, "int x")
  local top = 5
  local tw, th = bmp:MeasureText(time_text)
  bmp:DrawText(IMAGE_WIDTH - tw - 5, top, time_text, {128, 128, 128})
  tw, th = bmp:MeasureText(title_text)
  bmp:DrawText((IMAGE_WIDTH - tw) // 2, top, title_text, {128, 128, 128})
  top = top + th + 5
  tw, th = bmp:MeasureText(info)
  bmp:DrawText((IMAGE_WIDTH - tw) // 2, top, info, {128, 128, 128})
  top = top + th + 5
  tw, th = bmp:MeasureText(info2)
  bmp:DrawText((IMAGE_WIDTH - tw) // 2, top, info2, {128, 128, 128})
  tw, th = bmp:MeasureText(info3)
  bmp:DrawText((IMAGE_WIDTH - tw) // 2, IMAGE_HEIGHT - 20, info3, {128, 128, 128})
  bmp:WriteBMP(filename)
end

local function RunKnapsackGA(knapsack)
  start_clock = os.clock()
  
  WEIGHTS = knapsack.ItemWeights
  CHROMOSOME_LENGTH = #WEIGHTS
  MUTATION_RATE = 1.0 / CHROMOSOME_LENGTH
  MUTATION_RATE = 0.002
  local w1, w2 = knapsack.Weights[1], knapsack.Weights[2]
  MAX_WEIGHT = w1

  local stats =
  {
    funcs =
    {
      ["Min"] = { color = {0, 0, 255} },
      ["Max"] = { color = {0, 255, 0} },
      ["Avg"] = { color = {255, 0, 0} },
    },
    name_x = "Generation #",
    name_y = "Fitness",
  }
  
  local init_pop = GenInitPop(knapsack.pop_size, CHROMOSOME_LENGTH)
  EvalPop(init_pop)
  PlotPop(init_pop, stats.funcs, 1)
  
  local pop = init_pop
  local crossovers, mutations = 0, 0
  local first_gen = {}
  for gen = 2, knapsack.max_gens do
    if gen % 100 == 0 then print(string.format("Gen # %d/%d", gen, knapsack.max_gens)) end
    if gen % knapsack.WeightsPeriod == 0 then
      MAX_WEIGHT = (MAX_WEIGHT == w1) and w2 or w1
    end
    local new_pop = { crossovers = pop.crossovers, mutations = pop.mutations }
    while #new_pop < knapsack.pop_size do
      -- Roulette Wheel selection
      local idx1 = SelRW(pop)
      local idx2 = SelRW(pop)
      
      -- crossover
      local off1, off2, crossovers = Crossover(pop[idx1], pop[idx2])
      new_pop.crossovers = new_pop.crossovers + crossovers
      
      -- mutation
      local mut1 = Mutate(off1)
      local mut2 = Mutate(off2)
      
      table.insert(new_pop, off1)
      new_pop.mutations = new_pop.mutations + mut1
      -- shield in case population size is odd number
      if #new_pop < knapsack.pop_size then
        table.insert(new_pop, off2)
        new_pop.mutations = new_pop.mutations + mut2
      end
    end
    EvalPop(new_pop)
    pop = new_pop
    PlotPop(pop, stats.funcs, gen)
    if (MAX_WEIGHT == w1) and (not first_gen[w1]) and (pop.max_fitness == MAX_WEIGHT) then
      local ind = table.find_entry(pop, "fitness", MAX_WEIGHT)
      local chrom = DIPLOID and GetExprChrom(ind) or ind.chrom
      first_gen[w1] = { gen = gen, list = EvalWeightsList(chrom) }
    end
    if (MAX_WEIGHT == w2) and (not first_gen[w2]) and (pop.max_fitness == MAX_WEIGHT) then
      local ind = table.find_entry(pop, "fitness", MAX_WEIGHT)
      local chrom = DIPLOID and GetExprChrom(ind) or ind.chrom
      first_gen[w2] = { gen = gen, list = EvalWeightsList(chrom) }
    end
  end

  local time = os.clock() - start_clock
  local time_text = string.format("Time (Lua 5.3): %ss", time)
  local info = string.format("Population: %d, Generation found: W1=%s, W2=%s", #pop, first_gen[w1] and first_gen[w1].gen or ":(", first_gen[w2] and first_gen[w2].gen or ":(")
  local info2 = string.format("W1 list: {%s}, W2 list: {%s}", first_gen[w1] and table.concat(first_gen[w1].list, ",") or "", first_gen[w2] and table.concat(first_gen[w2].list, ",") or "")
  local ga_type = DIPLOID and (TRIALELIC and "Diploid Tri-Alelic" or "Diploid Bi-Alelic") or "Haploid"
  local info3 = string.format("%s GA, Crossovers: %d, Mutations: %d", ga_type, pop.crossovers, pop.mutations)
  
  DrawGraph(knapsack.max_filename, stats, "Max", w1, w2, knapsack.max_gens, knapsack.title, time_text, info, info2, info3)
  DrawGraph(knapsack.avg_filename, stats, "Avg", w1, w2, knapsack.max_gens, knapsack.title, time_text, info, info2, info3)
end

RunKnapsackGA(s_Knapsacks[9])
--[[
for _, knapsack in ipairs(s_Knapsacks) do
  for _, diploid in ipairs{false, true} do
    DIPLOID = diploid
    local allelic = { [false] = {false}, [true] = {false, true} }
    for _, trialelic in ipairs(allelic[diploid]) do
      TRIALELIC = trialelic
      math.randomseed(1234)
      RunKnapsackGA(knapsack)
    end
  end
end
--]]