declare namespace saxon="http://saxon.sf.net/";
declare option saxon:output "indent=yes";

(: Se declaran los posibles Errores del Archivo :)
let $ErrorY := "<error>Year must not be empty</error>"
let $ErrorST := "<error>Series Type must not be empty</error>"
let $ErrorD := "<error>Driver information is incomplete</error>"
let $ErrorS := "<error>Driver statistics are incomplete</error>"

(: Se importan los documentos XML necesarios para la consulta :)
let $driversList := doc("drivers_list.xml")
let $driversStandings := doc("drivers_standings.xml")

(: Se verifica que el documento tenga year y seriesType :)
let $year := string($driversStandings/series/season/@year)
let $serieType := string($driversStandings/series/@name)

(: Se verifica si hay errores :)
let $errors :=
  let $errs := ()
  return
  
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
    return
      if (empty($full_name) or empty($country) or empty($birth_date) or empty($birth_place))
      then ($errs, $ErrorD)
      else $errs,
      if (empty($rank) or empty($season_points) or empty($wins) or empty($poles) or empty($races_not_finished) or empty($laps_completed))
      then ($errs, $ErrorS)
      else $errs

(: Se genera el archivo XML de salida :)
return
  if (exists($errors))
  then <nascar_data>{distinct-values($errors)}</nascar_data>
  else
    <nascar_data>
      <year>{$year}</year>
      <serie_type>{$serieType}</serie_type>
      <drivers>
        {
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
        return
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
        }
      </drivers>
    </nascar_data>
