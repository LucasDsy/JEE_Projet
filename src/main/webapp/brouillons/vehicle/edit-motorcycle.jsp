<%@ page import="model.vehicle.State" %><%--
  Created by IntelliJ IDEA.
  User: alexis_choupault
  Date: 17/11/2020
  Time: 10:37
  To change this template use File | Settings | File Templates.
--%>
<div class="modal fade bd-example-modal-lg" id="editMotorcycle" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg">
        <form method="POST" action="${action}">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">${actionTitle} une fiche moto</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="form-group col-3">
                            <label for="brandName">Marque</label>
                            <input type="text" class="form-control" value="${marque}" id="brandName" name="brand" required>
                        </div>

                        <div class="form-group col-3">
                            <label for="modelName">Modèle</label>
                            <input type="text" class="form-control" value="${model}"id="modelName" name="model" required>
                        </div>

                        <div class="form-group col-3">
                            <label for="power">Puissance</label>
                            <input type="number" min="0" max="10000" class="form-control" value="${power}" id="power" name="email" required>
                        </div>

                        <div class="form-group col-3">
                            <label for="maxSpeed">Vitesse maximum</label>
                            <input type="number" min="0" max="10000" class="form-control" value="${maxSpeed}" id="maxSpeed" name="maxSpeed" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="form-group col-6">
                            <label for="state">État</label>
                            <input type="text" list="state_list" id="state" name="state">
                            <datalist class="form-control" id="state_list">
                                <% for (State state : State.values()) { %>
                                <option value="<%= state.toString() %>">
                            </datalist>
                        </div>

                        <div class="form-group col-6">
                            <label for="maxSpeed">Kilométrage</label>
                            <input type="number" min="0" max="1000000" class="form-control" value="${kilometers}" id="kilometers" name="kilometers" required>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Fermer</button>
                    <button type="submit" class="btn btn-primary">${actionTitle}</button>
                </div>
            </div>
        </form>
    </div>
</div>