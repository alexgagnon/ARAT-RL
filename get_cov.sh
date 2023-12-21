NO_INTERVAL=1
TIME_INTERVAL=$TIME_LIMIT

echo $TIME_INTERVAL
echo $TIME_LIMIT

TIME_INTERVAL=$(($TIME_LIMIT * 60 - 2))
echo $TIME_INTERVAL

SET=$(seq 1 "$NO_INTERVAL")
for i in $SET
do
    sleep "$TIME_INTERVAL"s
    java -jar org.jacoco.cli-0.8.7-nodeps.jar dump --address localhost --port "$1" --destfile "$2"/jacoco_"$1"_"$i".exec
done
