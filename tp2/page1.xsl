<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

<xsl:template match="countries">
<html>
<head>
	<title>Pays</title>
	<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
	<style>
		.bar {
		  fill: #aaa;
		  height: 21px;
		  -webkit-transition: fill .3s ease;
		  transition: fill .3s ease;
		  cursor: pointer;
		  font-family: Helvetica, sans-serif;
		}
		.bar text {
		  fill: #555;
		}

		.chart:hover .bar,
		.chart:focus .bar {
		  fill: #aaa;
		}

		.bar:hover,
		.bar:focus {
		  fill: red !important;
		}
		.bar:hover text,
		.bar:focus text {
		  fill: red;
		}
	</style>
</head>
<body>
	<div class="container-fluid p-3">
		<div class="row h-100">
			<div class="col-12 col-sm-2">
				<ul class="nav flex-column card">
					<xsl:for-each select="country">
					  <li class="nav-item">
					    <a class="nav-link" href="#{concat(@population,@area)}">
								<xsl:value-of select="@name" />
							</a>
					  </li>
					</xsl:for-each>
				</ul>
			</div>
			<div class="col-12 col-sm-10">
				<div class="row h-100">
					<xsl:apply-templates>
						<xsl:sort select="@name" order="ascending" data-type="text"/>
						<xsl:sort select="@population" order="ascending" data-type="number"/>
						<xsl:sort select="@area" order="ascending" data-type="number"/>
					</xsl:apply-templates>
				</div>
			</div>
		</div>
	</div>
	<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
	<script>
		$(document).on('click', '.nav-link', (e) => {
			var id_panel = $(e.target).attr('href');
			$('.panel').addClass('d-none');
			$(id_panel).removeClass('d-none');
		});
	</script>
</body>
</html>
</xsl:template>

<xsl:template match="country">
	<xsl:variable name="totalPopulation" select="@population"/>
	<div class="col-12 d-none panel">

		<xsl:attribute name="id">
			<xsl:value-of select="concat(@population,@area)"/>
		</xsl:attribute>

		<div class="card h-100 p-3">
			<h2><xsl:value-of select="@name"/></h2>
			<div class="card p-3 m-1">
				<h4>Infos générales</h4>
				<table class="table mt-1">
					<tbody>
				    <tr>
				      <th scope="row">Population</th>
				      <td><xsl:value-of select="@population"/></td>
				    </tr>
				    <tr>
				      <th scope="row">Superficie</th>
				      <td><xsl:value-of select="@area"/></td>
				    </tr>
				  </tbody>
				</table>
			</div>
			<xsl:if test="city">
				<div class="card p-3 m-1">
					<h4>Villes</h4>
					<ul class="list-group">
						<xsl:apply-templates select="city">
							<xsl:with-param name="totalPopulation" select="$totalPopulation"/>
						</xsl:apply-templates>
					</ul>
				</div>
			</xsl:if>
			<xsl:if test="language">
				<div class="card p-3 m-1">
					<h4>Langues parlées</h4>
					<ul class="list-group">
						<xsl:apply-templates select="language"/>
					</ul>
				</div>
			</xsl:if>
			<xsl:if test="city">
				<div class="card h-100 p-3 m-1">
					<h4>Histogramme villes</h4>
					<div class="h-100 w-100 px-4 py-3">
						<figure>
							<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" class="chart" width="100%" height="100%" aria-labelledby="title" role="img">
								<title>Histogramme</title>
								<xsl:for-each select="city">
									<xsl:sort select="population" order="descending" data-type="number"/>
									<xsl:variable name="percentagePopulation" select="format-number((population div $totalPopulation) * 100, '##.##')"/>
								 	<g class="bar">
								    <rect height="19" width="{$percentagePopulation*10}" y="{position()*20}">
										</rect>
								    <text x="{$percentagePopulation*10+10}" y="{position()*20+9}" dy=".35em"><xsl:value-of select="name"/> (<xsl:value-of select="$percentagePopulation"/> %)</text>
								  </g>
								</xsl:for-each>
							</svg>
						</figure>
					</div>
				</div>
			</xsl:if>
		</div>
	</div>
</xsl:template>

<xsl:template match="city">
	<xsl:param name="totalPopulation"/>
	<li class="list-group-item">
		<xsl:value-of select="name"/>: <xsl:value-of select="population"/> d'habitants (<xsl:value-of select="format-number((population div $totalPopulation) * 100, '##.##')"/> % de la population totale)
	</li>
</xsl:template>

<xsl:template match="language">
	<li class="list-group-item"><xsl:apply-templates />: <xsl:value-of select="@percentage"/> %</li>
</xsl:template>

</xsl:stylesheet>
