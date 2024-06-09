declare option saxon:output "indent=yes";

(: Se importan los documentos XML necesarios para la consulta :)
(: Se pasan los docs a variables para mayor claridad del código :)
let $driversList := doc("drivers_list.xml")
let $driversStandings := doc("drivers_standings.xml")

(: Crear un archivo XML de salida y agregar datos a medida que se procesa la consulta :)

return <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="nascar_data.xsd">
  <year>{string($driversStandings/series/season/@year)}</year>
  <serie_type>{string($driversStandings/series/@name)}</serie_type>
  <drivers>
  {
  for $driver in $driversStandings//driver
  return 
  <driver>
    <full_name>{string($driversList//driver[@id = $driver/@id]/@full_name)}</full_name>
    <country>{string($driversList//driver[@id = $driver/@id]/@country)}</country>
    <birth_date>{string($driversList//driver[@id = $driver/@id]/@birthday)}</birth_date>
    <birth_place>{string($driversList//driver[@id = $driver/@id]/@birth_place)}</birth_place>
    <rank>{string($driver/@rank)}</rank>
    {
    if (count($driversList//driver[@id = $driver/@id]/car) > 0 )
    then <car>{string($driversList//driver[@id = $driver/@id]/car[not(preceding-sibling::car)]/manufacturer/@name)}</car>
    else ()
    }
      <statistics>
        <season_points>{string($driver/@points)}</season_points>
        <wins>{string($driver/@wins)}</wins>
        <poles>{string($driver/@poles)}</poles>
        <races_not_finished>{string($driver/@dnf)}</races_not_finished>
        <laps_completed>{string($driver/@laps_completed)}</laps_completed>
      </statistics>
    </driver>
  }
    </drivers>
  </nascar_data>

    
  
