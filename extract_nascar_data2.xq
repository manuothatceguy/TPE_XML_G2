declare namespace saxon="http://saxon.sf.net/";
declare option saxon:output "indent=yes";

(: Se declaran los posibles Errores del Archivo :)
let $ErrorY := "<error>Year must not be empty</error>"
let $ErrorST := "<error>Series Type must not be empty</error>"
let $ErrorD := "<error>Driver information is incomplete</error>"
let $ErrorS := "<error>Driver statistics are incomplete</error>"

(: Se importan los documentos XML necesarios para la consulta :)
(: Se pasan los docs a variables para mayor claridad del código :)
let $driversList := doc("drivers_list.xml")
let $driversStandings := doc("drivers_standings.xml")

(: Se verifica que el documento tenga year y seriesType  :)
let $year := string($driversStandings/series/season/@year)
let $serieType := string($driversStandings/series/@name)

let $errors := ""

(: Se no estan presenta se agrega a errors :)
let $errors := 
  if (empty($year)) 
  then concat($errors, $ErrorY) 
  else $errors
let $errors := 
  if (empty($serieType)) 
  then concat($errors, $ErrorST) 
  else $errors


return
  if ($errors != "")
  then $errors
  else
    let $drivers := 
    for $driver in $driversStandings//driver
    let $full_name := string($driversList//driver[@id = $driver/@id]/@full_name)
    let $country := string($driversList//driver[@id = $driver/@id]/@country)
    let $birth_date := string($driversList//driver[@id = $driver/@id]/@birthday)
    let $birth_place := string($driversList//driver[@id = $driver/@id]/@birth_place)
    let $rank := string($driver/@rank)
    let $season_points := string($driver/@points)
    let $wins := string($driver/@wins)
    let $poles := string($driver/@poles)
    let $races_not_finished := string($driver/@dnf)
    let $laps_completed := string($driver/@laps_completed)

    (: Se chequea si falta información del conductor y de las estadisticas del mismo :)
    let $errors := 
      if (empty($full_name) or empty($country) or empty($birth_date) or empty($birth_place) or empty($rank)) 
      then concat($errors, $ErrorD) 
      else $errors
    let $errors := 
      if (empty($season_points) or empty($wins) or empty($poles) or empty($races_not_finished) or empty($laps_completed)) 
      then concat($errors, $ErrorS) 
      else $errors

    return
      if ($errors != "")
      then $errors
      else
        <driver>
          <full_name>{$full_name}</full_name>
          <country>{$country}</country>
          <birth_date>{$birth_date}</birth_date>
          <birth_place>{$birth_place}</birth_place>
          <rank>{$rank}</rank>
          {
          if (count($driversList//driver[@id = $driver/@id]/car) > 0 )
          then <car>{string($driversList//driver[@id = $driver/@id]/car[not(preceding-sibling::car)]/manufacturer/@name)}</car>
          else ()
          }
          <statistics>
            <season_points>{$season_points}</season_points>
            <wins>{$wins}</wins>
            <poles>{$poles}</poles>
            <races_not_finished>{$races_not_finished}</races_not_finished>
            <laps_completed>{$laps_completed}</laps_completed>
          </statistics>
        </driver>

    let $result :=
      <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:noNamespaceSchemaLocation="nascar_data.xsd">
        <year>{$year}</year>
        <serie_type>{$serieType}</serie_type>
        <drivers>
          {$drivers}
        </drivers>
      </nascar_data>
    return $result



