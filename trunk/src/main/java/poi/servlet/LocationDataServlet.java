package poi.servlet;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;

/**
 * User: jakerosenhaft
 * Date: 5/16/13
 *
 * This servlet responds to a request of the form http://.../locationData/PROFILE, returning a KML response
 * containing locations associated with the requested profile.  For now, the servlet simply returns the contents of a file using a naming convention but
 * in the future, the idea is that the servlet could pull locations from a database, allowing us to make it easy for both users and administrators to add
 * profiles and locations without having to change the UI that actually uses this data.
 */
public class LocationDataServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String profileName = request.getPathInfo();

        if (profileName.length() < 2)
        {
            response.setStatus(404);
        }
        else
        {
            profileName = profileName.substring(1);

            try {
                outputLocationData(response, profileName);
            }
            catch (Exception e) {
                System.out.println("Error returning data for " + profileName);
                e.printStackTrace();
                response.setStatus(404);
            }
        }
    }

    /**
     * For now, just read and serve up static data from a file.
     *
     * @param response
     * @param profileName
     * @throws Exception
     */
    private void outputLocationData(HttpServletResponse response, String profileName)
    throws Exception {
        response.setContentType("text/xml");
        String dataFile = "/WEB-INF/resources/" + profileName + ".kml";
        InputStream kmlStream = getServletContext().getResourceAsStream(dataFile);
        if (kmlStream == null)
        {
            throw new Exception("Resource not found " + dataFile);
        }
        copyStream(kmlStream, response.getOutputStream());
        System.out.println("Sent data for " + profileName);
    }

    private void copyStream(InputStream input, ServletOutputStream output)
    throws IOException {
        byte[] buf = new byte[8192];
        while (true) {
            int length = input.read(buf);
            if (length < 0)
                break;
            output.write(buf, 0, length);
        }

        try {
            input.close();
        } catch (IOException ignore) {
        }
        try {
            output.close();
        } catch (IOException ignore) {
        }
    }
}
