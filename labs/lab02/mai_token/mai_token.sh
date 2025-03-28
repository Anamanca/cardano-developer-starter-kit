#apt upgrade
#apt update
#apt install xxd

#1- Thiết lập biến môi trường
testnet="--testnet-magic 2"
address=$(cat ../base.addr)
address_SKEY="payment.skey"
cardano-cli query utxo --address $address $testnet

txhash="d8a374c979a4d0a38717538938d678a87db87c14c93395e09d9909ed65bb5419"
txix="4"
output="10000000"
ipfs_hash="QmTkxKzd91FMdF6xVKCE1Q8GFyW7zufne6jr18XZh892Pb"
realtokenname="Test_408"
tokenname=$(echo -n $realtokenname | xxd -ps | tr -d '\n')
tokenamount="10000"

#2-Tạo thư mục và Policy
# tùy chọn -p để tránh lỗi khi thư mục đã tồn tại rồi
#mkdir -p tokens; cd tokens
#mkdir -p policy
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey

# tạo file policy.script va xoa tat ca noi dung, sau do xuong dong
touch policy/policy.script && echo "" > policy/policy.script

echo "{" >> policy/policy.script
echo "  \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey)\"," >> policy/policy.script
echo "  \"type\": \"sig\"" >> policy/policy.script
echo "}" >> policy/policy.script

##===== Đọc lại nội dung file policy.script để kiêm tra
#cat policy/policy.script
cardano-cli conway transaction policyid --script-file ./policy/policy.script > policy/policyID
#cat policy/policyID
policyid=$(cat policy/policyID)

#4-Tạo metadata cho token
touch metadata.json && echo -n "" > metadata.json

echo "{" >> metadata.json
echo "  \"721\": {" >> metadata.json
echo "    \"$(cat policy/policyID)\": {" >> metadata.json
echo "      \"$(echo $realtokenname)\": {" >> metadata.json
echo "        \"Class\": \"C2VN_BK03\"," >> metadata.json
echo "        \"name\": \"Nguyễn Trung Hiếu\"," >> metadata.json
echo "        \"Student_no\": \"408\"," >> metadata.json
echo "        \"image\": \"ipfs://$(echo $ipfs_hash)\"," >> metadata.json
echo "        \"Module\": \"module 1-CLI\"" >> metadata.json
echo "      }" >> metadata.json
echo "    }" >> metadata.json
echo "  }" >> metadata.json
echo "}" >> metadata.json

#cat metadata.json

echo $policyid.$tokenname > policy_token.log

#4-Tạo giao dịch
cardano-cli conway transaction build \
$testnet \
--tx-in $txhash#$txix \
--tx-out $address+$output+"$tokenamount $policyid.$tokenname" \
--mint "$tokenamount $policyid.$tokenname" \
--mint-script-file policy/policy.script \
--metadata-json-file metadata.json \
--change-address $address \
--out-file mint-nft.raw


#5-Tạo ký giao dịch
cardano-cli conway transaction sign  $testnet \
--signing-key-file ../$address_SKEY  \
--signing-key-file policy/policy.skey  \
--tx-body-file mint-nft.raw \
--out-file mint-nft.signed

#5-Gửi giao dịch 

cardano-cli conway transaction submit $testnet --tx-file mint-nft.signed 