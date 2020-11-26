<%@ page import="model.people.Customer" %>
<%@ page import="java.util.Map" %>
<%@ page import="static servlet.CommercialServlet.CUSTOMERS" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Map<Customer, Double> customers = (Map<Customer, Double>) request.getAttribute(CUSTOMERS);
%>
<html>
<head>
    <meta charset="utf-8">
    <title>Gestion des clients</title>
    <jsp:include page="/css/mdb-css.jsp"/>
    <jsp:include page="/js/mdb-js.jsp"/>
</head>
<header>
    <jsp:include page="../templates/nav.jsp" />
</header>
<body>
    <div class="container">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Nom</th>
                    <th scope="col">Prénom</th>
                    <th scope="col">Total dépense</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map.Entry<Customer, Double> entry : customers.entrySet()) {
                    Customer customer = entry.getKey();
                    Double sum = entry.getValue();
                %>
                    <tr>
                        <th scope="row"><%= customer.getId() %></th>
                        <td><%= customer.getLastName() %></td>
                        <td><%= customer.getFirstName() %></td>
                        <td><%= String.format("%.2f", sum) %> €</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>