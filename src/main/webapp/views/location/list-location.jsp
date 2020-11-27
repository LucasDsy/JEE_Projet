<%@ page import="model.Location" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="static servlet.CustomerServlet.ERRORS" %>
<%@ page import="static servlet.CustomerServlet.RESULT" %>
<%@ page import="static servlet.LocationServlet.*" %>
<%@ page import="utils.URLUtil" %>
<%@ page import="model.people.State" %>
<%@ page import="model.people.Customer" %>
<%@ page import="model.vehicle.Vehicle" %>
<%@ page import="model.people.Employee" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String result = (String) request.getAttribute(RESULT);
    HashSet<String> errorsList = (HashSet<String>) request.getAttribute(ERRORS);
    List<Location> locations = (List) request.getAttribute(LOCATION_ATTRIBUTE);
%>
<html>
<head>
    <meta charset="utf-8">
    <title>Gestion des locations</title>
    <jsp:include page="/css/mdb-css.jsp"/>
    <jsp:include page="/js/mdb-js.jsp"/>
</head>
<body>
    <header>
        <jsp:include page="/views/templates/nav.jsp"/>
    </header>
    <% if(errorsList != null && !errorsList.isEmpty()){%>
    <div class="container">
        <span class="text-danger"><%=result%></span><br/>
        <% for(String err : errorsList){%>
            <span class="text-danger"><%=err%></span><br/>
        <%}%>
    </div>
        <%} else if(result!=null){%>
            <span class="text-success"><%=result%></span><br/>
        <%}%>
        <div class="container-fluid">
            <table id="dtVehicles" class="table table-striped">
                <thead>
                <tr>
                    <th class="th-sm">Loueur</th>
                    <th class="th-sm">Véhicule</th>
                    <th class="th-sm">Gestionnaire</th>
                    <th class="th-sm">Prix</th>
                    <th class="th-sm">Km (estimé)</th>
                    <th class="th-sm">Km (réel)</th>
                    <th class="th-sm">Date début</th>
                    <th class="th-sm">Date fin</th>
                    <th class="th-sm">Etat</th>
                    <th class="th-sm">Supprimer</th>
                    <th class="th-sm">Finaliser</th>
                </tr>
                </thead>
                <tbody>
                    <% if (locations != null) { %>
                        <% for (Location location : locations) { %>
                            <tr>
                                <td>
                                    <% if(location.getClient() != null){%>
                                    <%= location.getClient().getFirstName() %> <%= location.getClient().getLastName() %>
                                    <%}else{%>
                                    Ancien client
                                    <%}%>
                                </td>
                                <td>
                                    <% if(location.getVehicle() != null){%>
                                    <%= location.getVehicle().getModel() %> <%= location.getVehicle().getBrand() %>
                                    <%}else{%>
                                    Ancien véhicule
                                    <%}%>
                                </td>
                                <td>
                                    <% if(location.getEmployee() != null){%>
                                    <%= location.getEmployee().getFirstName() %> <%= location.getEmployee().getLastName() %>
                                    <%}else{%>
                                    Ancien employé
                                    <%}%>
                                </td>
                                <td><%= String.format("%.2f", location.getPrice()) + " € " + ((location.getStatus() == State.InProgress || location.getStatus() == State.Booked)?" (Estimation)":"")%></td>
                                <td><%= location.getEstimatedKm() %></td>
                                <td><%= location.getStatus() == State.Completed?location.getKmReel() : "-" %></td>
                                <td><%= new SimpleDateFormat("dd/MM/yyyy").format(location.getStartDate().getTime()) %></td>
                                <td><%= new SimpleDateFormat("dd/MM/yyyy").format(location.getEndDate().getTime()) %></td>
                                <td><%= location.getStatus().getWording() %></td>
                                <td><button class="btn btn-danger btn-sm" data-toggle="modal" data-target="#delLocation<%=location.getId()%>"><i class="fas fa-trash"></i></button></td>
                                <% if (location.getStatus()!= State.Completed && location.getStatus()!=State.Cancelled){%>
                                    <td><button class="btn btn-success btn-sm" data-toggle="modal" data-target="#endLocation<%=location.getId()%>"><i class="fas fa-check"></i></button></td>
                                <% } else { %>
                                    <td></td>
                                <% } %>
                                <jsp:include page="modal/delete-location.jsp" flush="true">
                                    <jsp:param name="id" value="<%=location.getId()%>"/>
                                </jsp:include>
                                <jsp:include page="modal/end-location.jsp" flush="true">
                                    <jsp:param name="id" value="<%=location.getId()%>"/>
                                    <jsp:param name="price" value="<%=String.valueOf(location.getActualPrice())%>"/>
                                </jsp:include>
                            </tr>
                        <%}%>
                    <%}%>
                </tbody>
            </table>
        </div>
        <div style="position:fixed; bottom: 25px; right: 24px;"><button class="btn btn-dark-green rounded-pill" data-toggle="modal" data-target="#createLocation"><i class="fas fa-plus"></i> Ajouter</button></div>
        <jsp:include page="modal/create-location.jsp"/>
    </body>
</html>
<script>
    const url = "<%= URLUtil.baseUrl("location")%>";

    function deleteLocation(id) {
        const data = {};
        data.id = id;

        fetch(url, {
            //credentials: 'same-origin', // 'include', default: 'omit'

            method: 'DELETE',
            body: JSON.stringify(data),
            redirect: "follow",
            headers: new Headers({
                'Content-Type': 'application/json'
            }),
        })
        .then(response => {
            if(response.status === 200 || response.status === 0) {
                window.location.href = url;
            } else {
                response.json().then(data => writeErrors(data))
            }
        })
        .catch(error => console.error(error))
    }

    function writeErrors(json) {
        let div = document.createElement('div');
        div.setAttribute("class", "containter");

        let spanResult = document.createElement('span')
        spanResult.setAttribute("class", "text-danger");
        spanResult.innerText = json.<%= RESULT %>;

        div.appendChild(spanResult);
        div.appendChild(document.createElement('br'));

        for(error of json.<%= ERRORS %>) {
            let errorSpan = document.createElement('span')
            errorSpan.setAttribute("class", "text-danger");
            errorSpan.innerText = error;

            div.appendChild(errorSpan);
            div.appendChild(document.createElement('br'));
        }

        document.body.insertBefore(div, document.body.firstChild);
    }

    function endLocation(id) {
        let data = {
            locationId: id,
        };

        fetch(url, {
            //credentials: 'same-origin', // 'include', default: 'omit'

            method: 'PUT',
            body: JSON.stringify(data),
            redirect: "follow",
            headers: new Headers({
                'Content-Type': 'application/json'
            }),
        })
            .then(function (response) {
                    console.log(response);

                }
            )
            .catch(error => console.error(error))
    }

    function sendKm(id){
        km = document.getElementById('km'+id).value;
        let data = {
            locationId: id,
            actualDistance : km
        };

        fetch(url, {

            method: 'PUT',
            body: JSON.stringify(data),
            redirect: "follow",
            headers: new Headers({
                'Content-Type': 'application/json'
            })
        })
            .then(function (response) {
                response.json().then(data => {
                    document.getElementById("price"+id).innerHTML=Math.round(data.price*100)/100
                })
            })
            .catch(error => console.error(error))
    }

</script>