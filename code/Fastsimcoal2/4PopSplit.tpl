//Parameters for the coalescence simulation program : simcoal.exe
4 samples to simulate :
//Population effective sizes (number of genes)
NHCA
NHSA
NHYP
NCAU
//Samples sizes and samples age
10
8
42
66
//Growth rates: negative growth implies population expansion
0
0
0
0
//Number of migration matrices : 0 implies no migration between demes
0
//historical event: time, source, sink, migrants, new deme size, growth rate, migr mat index
3 historical event
TH 2 0 1 RESIZE1 0 0
TC 3 1 1 RESIZE2 0 0
TDIV 0 1 1 RESIZE3 0 0
//Number of independent loci [chromosome]
16 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per gen recomb and mut rates
FREQ 1 3.6e-6 7e-9 OUTEXP

