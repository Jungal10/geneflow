
### All the scripts are in current working directory

./LoadCalculation-Sweep.sh  ####### Load in Sweep region
./LoadCalculation-NoSweep.sh   # Load in Control region

cat header.txt AllPOP-Sweeps-Final.txt AllPOP-NoSweeps-Final.txt > Sweep_Load.txt   ## Actual file for load used for plotting

R CMD BATCH Plot.R 

