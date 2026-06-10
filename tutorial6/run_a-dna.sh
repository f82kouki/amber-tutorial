#!/bin/bash
AMBERHOME=/home/ando/amber/amber18
MDSTARTJOB=2
MDENDJOB=10

echo "Starting Script at: $(date)"
echo ""

MDCURRENTJOB=$MDSTARTJOB
while [ $MDCURRENTJOB -le $MDENDJOB ]; do
    echo "Job $MDCURRENTJOB started at: $(date)"
    MDINPUT=$((MDCURRENTJOB - 1))
    $AMBERHOME/bin/sander -O -i a-dna_md_1800ps.in \
                             -o a-dna_md${MDCURRENTJOB}.out \
                             -p a-dna_wat.prmtop \
                             -c a-dna_md${MDINPUT}.ncrst \
                             -r a-dna_md${MDCURRENTJOB}.ncrst \
                             -x a-dna_md${MDCURRENTJOB}.nc
    gzip -9 -v a-dna_md${MDCURRENTJOB}.nc
    echo "Job $MDCURRENTJOB finished at: $(date)"
    MDCURRENTJOB=$((MDCURRENTJOB + 1))
done
echo "ALL DONE at: $(date)"
