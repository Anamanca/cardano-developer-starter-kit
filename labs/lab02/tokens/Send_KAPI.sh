#1- Thiết lập biến môi trường
testnet="--testnet-magic 2"
address_skey="payment.skey"

# Thong tin Token muon gui
realtokenname="KAPI_BK03"
tokenname=$(echo -n $realtokenname | xxd -ps | tr -d '\n')
policyid=$(cat policy/policyID)

# Thong tin nguoi gui
address_send=$(cat ../base.addr)
#cardano-cli query utxo --address $address_send $testnet

UTXO_IN_1=7300e974b6057da86952cabc4bae0183ce1a8379b4ccb3e32b6d6152e60beb17#0
UTXO_IN_2=907015a76d25a86b510a6ca78afe5d9822e86e7a1e73cef34dc61b5ec12d7004#1

#Thong tin nguoi nhan
address_Receive="addr_test1qz8shh6wqssr83hurdmqx44js8v7tglg9lm3xh89auw007dd38kf3ymx9c2w225uc7yjmplr794wvc96n5lsy0wsm8fq9n5epq"
Amount_ADA_Send=3000000
Amount_Token_Send="500"

# B1. Xây dựng giao dịch (Build Tx)

cardano-cli conway transaction build $testnet \
--tx-in $UTXO_IN_1 \
--tx-in $UTXO_IN_2 \
--tx-out $address_Receive+$Amount_ADA_Send+"$Amount_Token_Send $policyid.$tokenname" \
--change-address $address_send \
--out-file send_kapi.raw

# B2. Ký giao dịch (Sign Tx)

cardano-cli conway transaction sign $testnet \
--signing-key-file ../$address_skey \
--tx-body-file send_kapi.raw \
--out-file send_kapi.signed

# B3. Gửi giao dịch (Submit Tx)

cardano-cli conway transaction submit $testnet \
--tx-file send_kapi.signed