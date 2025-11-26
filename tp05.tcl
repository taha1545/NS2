# ============================================================
# TP05 - Modélisation et Évaluation des Performances des Réseaux
# ------------------------------------------------------------
# Réseau avec 8 nœuds, trafic CBR, rupture/restauration de lien
# ============================================================

# ----- 1. INITIALISATION -----
set ns [new Simulator]

# fichiers trace et NAM
set tracefile [open tp05.tr w]
$ns trace-all $tracefile

set namfile [open tp05.nam w]
$ns namtrace-all $namfile

# ----- COULEURS NAM (optionnel) -----
$ns color 1 Blue
$ns color 2 Red

# ----- 2. CREATION DES NOEUDS -----
for {set i 0} {$i < 9} {incr i} {
    set n($i) [$ns node]
}

# ----- 3. CREATION DES LIENS -----
# Caractéristiques : Full-duplex, 10Mb, 10ms, DropTail
proc add_link {ns n1 n2} {
    $ns duplex-link $n1 $n2 10Mb 10ms DropTail
}

add_link $ns $n(1) $n(3)
add_link $ns $n(2) $n(3)
add_link $ns $n(3) $n(4)
add_link $ns $n(4) $n(5)
add_link $ns $n(5) $n(8)
add_link $ns $n(4) $n(6)
add_link $ns $n(6) $n(7)
add_link $ns $n(7) $n(8)

# ----- 4. ROUTAGE DYNAMIQUE -----
$ns rtproto DV

# ----- 5. CONFIGURATION DES AGENTS DE TRANSPORT -----

# UDP agents
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
set udp8 [new Agent/UDP]

# couleurs NAM
$udp1 set class_ 1
$udp2 set class_ 2

# attacher UDP aux nœuds
$ns attach-agent $n(1) $udp1
$ns attach-agent $n(2) $udp2
$ns attach-agent $n(8) $udp8  ;# Récepteur commun

# Null agent (récepteur)
set null0 [new Agent/Null]
$ns attach-agent $n(8) $null0

# connecter sources à destination (n8)
$ns connect $udp1 $null0
$ns connect $udp2 $null0

# ----- 6. TRAFIC CBR -----

# CBR 1 : n1 → n8
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

# CBR 2 : n2 → n8
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2

# ----- 7. CINEMATIQUE DU TRAFIC -----

$ns at 1.0 "$cbr1 start"
$ns at 7.0 "$cbr1 stop"

$ns at 2.0 "$cbr2 start"
$ns at 6.0 "$cbr2 stop"

# ----- 8. RUPTURE ET RÉTABLISSEMENT DU LIEN -----

# Rupture du lien n5 – n8 à t = 4 s
$ns at 4.0 "$ns rtmodel-at 5 down"
$ns at 4.0 "$ns link-down $n(5) $n(8)"

# Rétablissement à t = 5 s
$ns at 5.0 "$ns rtmodel-at 5 up"
$ns at 5.0 "$ns link-up $n(5) $n(8)"

# ----- 9. FIN DE SIMULATION -----
$ns at 8.0 "finish"

proc finish {} {
    global ns tracefile namfile
    close $tracefile
    close $namfile
    exec nam tp05.nam &
    exit 0
}

$ns run
