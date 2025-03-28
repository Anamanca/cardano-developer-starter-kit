
testnet="--testnet-magic 2"
address=$(cat base.addr)
address_skey="payment.skey"
#cardano-cli query utxo $testnet --address $address
#cardano-cli query utxo --testnet-magic 2 --address addr_test1qp9y66z2sk7v09n6lr2z0ggtq7797p2st9c3f8876q0a6847hp7e6wuh3yd7f2ymejng663mwksar8kv6gr9fpj3447q2ct4sn

#chỉnh sửa lại giá trị các biến
# Địa chỉ gửi bài tập về nhà
# addr_test1qzldl9u0j6ap7mdugtdcre43f8dfrnv7uqd3a6furpyuzw3z70zawv8g3tyg7uh833x50geeul2vpyujyzac0d6dmgcsyu5akw
BOB_ADDR="addr_test1qz8shh6wqssr83hurdmqx44js8v7tglg9lm3xh89auw007dd38kf3ymx9c2w225uc7yjmplr794wvc96n5lsy0wsm8fq9n5epq"
VALUE=3000000

UTXO_IN=d8a374c979a4d0a38717538938d678a87db87c14c93395e09d9909ed65bb5419#3

# B1. Xây dựng giao dịch (Build Tx)


cardano-cli conway transaction build $testnet \
--tx-in $UTXO_IN \
--tx-out $BOB_ADDR+$VALUE \
--change-address $address \
--metadata-json-file metadata_test.json \
--out-file simple-tx.raw

# B2. Ký giao dịch (Sign Tx)

cardano-cli conway transaction sign $testnet \
--signing-key-file $address_skey \
--tx-body-file simple-tx.raw \
--out-file simple-tx.signed

# B3. Gửi giao dịch (Submit Tx)

cardano-cli conway transaction submit $testnet \
--tx-file simple-tx.signed

