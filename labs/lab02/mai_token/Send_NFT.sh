#1- Thiết lập biến môi trường
testnet="--testnet-magic 2"
address_skey="payment.skey"

# Thong tin Token muon gui
tokenid=$(cat policy_token.log)

# Thong tin nguoi gui
address_send=$(cat ../base.addr)
#cardano-cli query utxo --address $address_send $testnet

UTXO_IN_1=0616d8fca4184b45a6433f679951dc9816c050233c2a5ea656899283f28299b8#0
#UTXO_IN_2=907015a76d25a86b510a6ca78afe5d9822e86e7a1e73cef34dc61b5ec12d7004#1

#Thong tin nguoi nhan
address_Receive=$(cat ../base.addr)
Amount_ADA_Send=3000000
Amount_Token_Send="500"

# B1. Xây dựng giao dịch (Build Tx)

cardano-cli conway transaction build $testnet \
--tx-in $UTXO_IN_1 \
--tx-out $address_Receive+$Amount_ADA_Send+"$Amount_Token_Send $tokenid" \
--metadata-json-file metadata_gd.json \
--change-address $address_send \
--out-file send_nft.raw

# B2. Ký giao dịch (Sign Tx)

cardano-cli conway transaction sign $testnet \
--signing-key-file ../$address_skey \
--tx-body-file send_nft.raw \
--out-file send_nft.signed

# B3. Gửi giao dịch (Submit Tx)

cardano-cli conway transaction submit $testnet \
--tx-file send_nft.signed