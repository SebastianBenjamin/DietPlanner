<%@ page isErrorPage="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page errorPage="error.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error Occurred</title>
    <style>
        .error-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            border-radius: 8px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .error-header {
            font-size: 24px;
            margin-bottom: 20px;
        }
        .error-details {
            background-color: white;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .home-link {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #721c24;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-header">
        ⚠️ Oops! Something went wrong
    </div>

    <p>We encountered an error while processing your request.</p>

    <c:if test="${not empty requestScope['javax.servlet.error.message']}">
        <div class="error-details">
            <strong>Error:</strong> ${requestScope['javax.servlet.error.message']}<br>

            <c:if test="${not empty pageContext.exception}">
                <strong>Exception:</strong> ${pageContext.exception}<br>
                <strong>Stack Trace:</strong><br>
                <pre><c:forEach items="${pageContext.exception.stackTrace}" var="trace">
                    ${trace}
                </c:forEach></pre>
            </c:if>

            <c:if test="${not empty requestScope['javax.servlet.error.request_uri']}">
                <strong>Request URI:</strong> ${requestScope['javax.servlet.error.request_uri']}
            </c:if>
        </div>
    </c:if>

    <a href="${pageContext.request.contextPath}/" class="home-link">
        Return to Home Page
    </a>
</div>
</body>
</html>