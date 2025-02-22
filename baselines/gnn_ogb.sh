#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=accelerated


#SBATCH --output=log/Universal_MPNN_%j.output
#SBATCH --error=error/Universal_MPNN_%j.error
#SBATCH --account=hk-project-pai00023   # specify the project group

#SBATCH --chdir=/hkfs/work/workspace/scratch/cc7738-rebuttal/Universal-MP

# Notification settings:
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cshao676@gmail.com

# Request GPU resources
#SBATCH --gres=gpu:1

source /hkfs/home/project/hk-project-test-p0021478/cc7738/anaconda3/etc/profile.d/conda.sh

conda activate base

 
# <<< conda initialize <<<
module purge
module load devel/cmake/3.18   
module load devel/cuda/11.8   
module load compiler/gnu/12
conda activate EAsF
cd /hkfs/work/workspace/scratch/cc7738-rebuttal 
cd /hkfs/work/workspace/scratch/cc7738-rebuttal/Universal-MP/baselines
 
echo ">>> .bashrc executed: Environment and modules are set up. <<<"
# Print loaded modules

echo "Running command: time python  ogb_gnn.py  --data_name ppa  --gnn_model model --lr 0.01 --dropout 0.3 --l2 1e-4 --num_layers 1  --num_layers_predictor 3 --hidden_channels 128 --epochs 9999 --kill_cnt 10 --eval_steps 5  --batch_size 1024  --random_sampling"
echo "Start time: $(date)"

data_name=vessel
#SBATCH --job-name=gnn_%data_name
gnn_models=(GCN GIN SAGE GAT)

for model in "${gnn_models[@]}"; do
    # time python  ogb_gnn.py  --data_name ppa  --gnn_model $model --lr 0.01 --dropout 0.3 --l2 1e-4 --num_layers 1  --num_layers_predictor 3 --hidden_channels 128 --epochs 200 --kill_cnt 10 --eval_steps 5  --batch_size 1024  --random_sampling
    # time python  ogb_gnn.py  --data_name collab  --gnn_model $model --lr 0.01 --dropout 0.3 --l2 1e-4 --num_layers 1  --num_layers_predictor 3 --hidden_channels 128 --epochs 200 --kill_cnt 10 --eval_steps 5  --batch_size 1024  --random_sampling
    # time python  ogb_gnn.py  --data_name ddi  --gnn_model $model --lr 0.01 --dropout 0.3 --l2 1e-4 --num_layers 1  --num_layers_predictor 3 --hidden_channels 128 --epochs 200 --kill_cnt 10 --eval_steps 5  --batch_size 1024  --random_sampling
    # time python  ogb_gnn.py  --data_name citation2  --gnn_model $model --lr 0.01 --dropout 0.3 --l2 1e-4 --num_layers 1  --num_layers_predictor 3 --hidden_channels 128 --epochs 200 --kill_cnt 10 --eval_steps 5  --batch_size 1024  --random_sampling
    time python  ogb_gnn.py  --data_name $data_name  --gnn_model $model --lr 0.01 --dropout 0.3 --l2 1e-4 --num_layers 1  --num_layers_predictor 3 --hidden_channels 128 --epochs 200 --kill_cnt 10 --eval_steps 5  --batch_size 1024  --random_sampling --runs 1 
done
