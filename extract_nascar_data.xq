declare namespace saxon="http://saxon.sf.net/";
declare option saxon:output "indent=yes";

(: Se declaran los posibles errores del archivo :)
let $ErrorY := <error>Year must not be empty</error>
let $ErrorST := <error>Series Type must not be empty</error>
let $ErrorD := <error>Driver information is incomplete</error>
let $ErrorS := <error>Driver statistics are incomplete</error>

(: Se importan los documentos XML necesarios para la consulta :)
(: Se pasan los docs a variables para mayor claridad del código :)
let $driversList := doc("drivers_list.xml")
let $driversStandings := doc("drivers_standings.xml")

(: Se verifica que el documento tenga year y serieType :)
let $year := string($driversStandings/series/season/@year)
let $serieType := string($driversStandings/series/@name)

let $driverErrors := ()

(: Si no están presentes, se agregan a errores :)
let $errors := ()
let $errors := 
  if ($year = "") 
  then ($errors, $ErrorY) 
  else $errors
let $errors := 
  if ($serieType = "") 
  then ($errors, $ErrorST) 
  else $errors

(: Si hay errores, se construye el XML de salida con los errores :)
return
  if (count($errors) > 0)
  then
    <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="nascar_data.xsd">
      {$errors}
    </nascar_data>
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

      (: Se chequea si falta información del conductor y de las estadísticas del mismo :)

      let $driverErrors := 
        if ($full_name = "" or $country = "" or $birth_date = "" or $birth_place = "" or $rank = "") 
        then ($driverErrors, $ErrorD) 
        else $driverErrors
      let $driverErrors := 
        if ($season_points = "" or $wins = "" or $poles = "" or $races_not_finished = "" or $laps_completed = "") 
        then ($driverErrors, $ErrorS) 
        else $driverErrors
      return
        if ($driverErrors != "")
        then ()
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

return 
if (count($driverErrors) > 0)
then
  <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="nascar_data.xsd">
    {$driverErrors}
  </nascar_data>
else
  <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="nascar_data.xsd">
    <year>{$year}</year>
    <serie_type>{$serieType}</serie_type>
    <drivers>
      {$drivers}
    </drivers>
  </nascar_data>

(: Se construye el XML de salida :)

