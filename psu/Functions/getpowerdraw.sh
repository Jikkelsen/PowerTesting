FILE="platinum-atx-psu.csv"
SHELLY=10.10.10.155
declare -i COUNT=8640 # That's three days, every 30 seconds

echo "Time,CPU Usage (%),CPU1 Temp (°C),CPU2 Temp (°C),Power Draw,Voltage,Current" > $FILE
echo "Benchmarking for 3 days ... " 
for ((i = 0; i < COUNT; ++i))
do    
    # New time stamp (could be fixed variable, but this catches timeskew)
    TIME=$(date)
    
    # Crude way of getting CPU Package usage. Since all cores should be stressed at 100%, we're only interested in deviations from package, which should be at 100% at all times
    CPU_PACKAGE_USAGE=$(top -bn1 | grep "Cpu(s)" | head -1 | awk '{print 100 - $8}')

	# Extract CPU Temperatures. Applicaple for Synology devices; 
	CPU_C1_TEMP=$(cat /sys/class/hwmon/hwmon0/device/temp2_input | awk '{print $1 / 1000}')
	CPU_C2_TEMP=$(cat /sys/class/hwmon/hwmon0/device/temp3_input | awk '{print $1 / 1000}')
		
	# Get PowerDraw from Shelly
	ShellyInfo=$(curl --silent -X POST -d '{"id":1,"method":"Shelly.GetStatus"}' http://${SHELLY}/rpc | jq -r '.result."switch:0".apower','.result."switch:0".voltage','.result."switch:0".current')
	
	APOWER=$(echo $ShellyInfo | awk '{print $1}')
	VOLTAGE=$(echo $ShellyInfo | awk '{print $2}')
	CURRENT=$(echo $ShellyInfo | awk '{print $3}')

    # Write line to benchmark file
    echo "$TIME,$CPU_PACKAGE_USAGE,$CPU_C1_TEMP,$CPU_C2_TEMP,$APOWER,$VOLTAGE,$CURRENT" >> $FILE
    echo "$TIME: Took measurement"
    # Warmup period
    sleep 30
done

echo "Benchmark completed. Results saved in $FILE."

