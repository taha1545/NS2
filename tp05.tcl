# =============================
#   TP 05 – Simulation NS2
# =============================

set ns [new Simulator]

set tracefile [open tp05.tr w]
set namfile   [open tp05.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

for {set i 1} {$i <= 8} {incr i} {
    set n($i) [$ns node]
}

$ns duplex-link $n(1) $n(3) 10Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 10Mb 10ms DropTail
$ns duplex-link $n(3) $n(4) 10Mb 10ms DropTail
$ns duplex-link $n(3) $n(5) 10Mb 10ms DropTail
$ns duplex-link $n(4) $n(6) 10Mb 10ms DropTail
$ns duplex-link $n(5) $n(8) 10Mb 10ms DropTail
$ns duplex-link $n(6) $n(7) 10Mb 10ms DropTail
$ns duplex-link $n(7) $n(8) 10Mb 10ms DropTail

set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
set null1 [new Agent/Null]
$ns attach-agent $n(8) $null1
$ns connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set udp2 [new Agent/UDP]
$ns attach-agent $n(2) $udp2
set null2 [new Agent/Null]
$ns attach-agent $n(8) $null2
$ns connect $udp2 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2

$ns at 1.0 "$cbr1 start"
$ns at 7.0 "$cbr1 stop"

$ns at 2.0 "$cbr2 start"
$ns at 6.0 "$cbr2 stop"

$ns rtmodel-at 4.0 down $n(5) $n(8)
$ns rtmodel-at 5.0 up $n(5) $n(8)

proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam tp05.nam &
    exit 0
}

$ns at 8.0 "finish"
$ns run
