package filter;

import servlet.EmployeeLoginServlet;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

import static servlet.EmployeeLoginServlet.LOGIN_VIEW;
import static servlet.HomeServlet.INDEX_VIEW;

@WebFilter(
        urlPatterns = {"/*"},
        dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD},
        filterName = "MainFilter"
)
public class MainFilter implements Filter {

    private static final String CSS_PATH = "/css";
    private static final String JS_PATH = "/js";


    public void init(FilterConfig config) {}

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());

        //Allow CORS
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.addHeader("Access-Control-Allow-Methods","GET, OPTIONS, HEAD, PUT, POST, DELETE");


        // For HTTP OPTIONS verb/method reply with ACCEPTED status code
        if (request.getMethod().equals("OPTIONS")) {
            response.setStatus(HttpServletResponse.SC_ACCEPTED);
            return;
        }

        // Allow CSS and JS
        if (path.startsWith(JS_PATH) || path.startsWith(CSS_PATH)) {
            chain.doFilter(request,response);
            return;
        }

        // Allow login
        if(path.equals("/login") || path.equals(LOGIN_VIEW)) {
            chain.doFilter(request,response);
            return;
        }

        if (request.getSession().getAttribute(EmployeeLoginServlet.NAME_USER_SESSION) == null)
            response.sendRedirect("/LocaJee/login");
        else
            chain.doFilter(request,response);
    }

    public void destroy() {}
}