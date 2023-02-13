#! /bin/bash

func() {
  echo "Usage:"
  echo "source tf_vars_setting.sh [-h help] [-f OCI_CONFIG] [-c COMAPRTMENT_ID] [-p PUBLIC_KEY_PATH]"
  echo ""
  echo "Description:"
  echo "OCI_CONFIG : set default oci config path ( Default : ~/.oci/config )"
  echo "COMAPRTMENT_ID : set compartment ocid ( Default root compartment id same as tenancy ocid)"
  echo "PUBLIC_KEY_PATH : set ssh public key path ( Default : ~/.ssh/id_rsa.pub )"
}

setting() {

  find_default=false

  while read line; 
  do 
    if [ $find_default = true ]; then
      if  [[ "$line" == "["* ]]; then
        break;
      fi

      if  [[ "$line" == user=* ]]; then
        user_ocid=${line#*=}
      fi

      if  [[ "$line" == tenancy=* ]]; then
        tenancy=${line#*=}
      fi

      if  [[ "$line" == fingerprint=* ]]; then
        fingerprint=${line#*=}
      fi
      
      if  [[ "$line" == key_file=* ]]; then
        key_file=${line#*=}
      fi

      if  [[ "$line" == region=* ]]; then
        region=${line#*=}
      fi
    fi

    if [[ "$line" == "[DEFAULT]" ]]; then
      find_default=true
    fi
  done < "$oci_config"

  if [ "$compartment_ocid" = "" ]; then
    compartment_ocid=$tenancy
  fi

  if [ "$public_key_path" = "" ]; then
    public_key_path="$(cd ~/.ssh && pwd)/id_rsa.pub"
  fi

  export TF_VAR_user_ocid=$user_ocid
  export TF_VAR_fingerprint=$fingerprint
  export TF_VAR_tenancy_ocid=$tenancy
  export TF_VAR_region=$region
  export TF_VAR_private_key_path=$key_file
  export TF_VAR_compartment_ocid=$compartment_ocid
  export TF_VAR_bastion_ssh_public_key=$public_key_path

  echo "TF_VAR_user_ocid="$TF_VAR_user_ocid
  echo "TF_VAR_fingerprint="$TF_VAR_fingerprint
  echo "TF_VAR_tenancy_ocid="$TF_VAR_tenancy_ocid
  echo "TF_VAR_region="$TF_VAR_region
  echo "TF_VAR_private_key_path="$TF_VAR_private_key_path
  echo "TF_VAR_compartment_ocid="$TF_VAR_compartment_ocid
  echo "TF_VAR_bastion_ssh_public_key="$TF_VAR_bastion_ssh_public_key

}


OPTIND=1
go=true
compartment_ocid=""
public_key_path=""
oci_config="$(cd ~/.oci && pwd)/config"

while getopts ':hf:c:p:' option; do
  case "$option" in
    h) func
       go=false
       ;;
    f) oci_config=$OPTARG
       ;;
    c) compartment_ocid=$OPTARG
       ;;
    p) public_key_path=$OPTARG
       ;;
    :) printf "Missing argument for -%s\n" "$OPTARG" >&2
       func
       go=false
       ;;
   \?) printf "Illegal option -%s\n" "$OPTARG" >&2
       func
       go=false
       ;;
  esac
done
shift $((OPTIND - 1))

if [ $go = true ]; then 
  setting
fi
