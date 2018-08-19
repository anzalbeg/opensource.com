#!/bin/sh

# include parse_yaml function
my_dir="$(dirname "$0")"
. "$my_dir/parse_yaml.sh"

# read yaml file
eval $(parse_yaml fabric-artifacts/values.yaml "config_")

# access yaml content
export ORDERER_ADDR=$config_clusterIpRange".249.66:7050"
echo  "$ORDERER_ADDR"
#echo $config_clusterIpRange