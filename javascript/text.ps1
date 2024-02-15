
$x =  [char]([convert]::toint16('3D',16))
$x

$MYTEXT='Vegeta is stronger than Goku'
$MYCHAR_ARRAY=$MYTEXT.ToCharArray()
Foreach ($CHAR in $MYCHAR_ARRAY) {
$TEX_HEX = $TEX_HEX + " " + [System.String]::Format("{0:X2}", [System.Convert]::ToUInt32($CHAR))
}
$TEX_HEX


$MYHEX="56 65 67 65 74 61 20 69 73 20 73 74 72 6f 6e 67 65 72 20 74 68 61 6e 20 47 6f 6b 75"
$MYHEX_ARRAY=$MYHEX.Split("")
Foreach ($HEX in $MYHEX_ARRAY) {
$MYTEXT= $MYTEXT +  [char]([convert]::toint16($HEX,16))
}
$MYTEXT

# https://techexpert.tips/powershell/powershell-converting-text-hexadecimal/