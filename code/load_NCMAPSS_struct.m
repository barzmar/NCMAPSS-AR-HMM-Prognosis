
function data =load_NCMAPSS_struct (filename)
    
    data = struct();

    data.Datasets(1).Name = "A_dev";
    data.Datasets(1).Value = h5read(filename, "/A_dev");
    
    data.Datasets(2).Name = "A_test";
    data.Datasets(2).Value = h5read(filename, "/A_test");
    
    data.Datasets(3).Name = "A_var";
    data.Datasets(3).Value = h5read(filename, "/A_var");
    
    data.Datasets(4).Name = "T_dev";
    data.Datasets(4).Value = h5read(filename, "/T_dev");
    
    data.Datasets(5).Name = "T_test";
    data.Datasets(5).Value = h5read(filename, "/T_test");
    
    data.Datasets(6).Name = "T_var";
    data.Datasets(6).Value = h5read(filename, "/T_var");
    
    data.Datasets(7).Name = "W_dev";
    data.Datasets(7).Value = h5read(filename, "/W_dev");
    
    data.Datasets(8).Name = "W_test";
    data.Datasets(8).Value = h5read(filename, "/W_test");
    
    data.Datasets(9).Name = "W_var";
    data.Datasets(9).Value = h5read(filename, "/W_var");
    
    data.Datasets(10).Name = "X_s_dev";
    data.Datasets(10).Value = h5read(filename, "/X_s_dev");
    
    data.Datasets(11).Name = "X_s_test";
    data.Datasets(11).Value = h5read(filename, "/X_s_test");
    
    data.Datasets(12).Name = "X_s_var";
    data.Datasets(12).Value = h5read(filename, "/X_s_var");
    
    data.Datasets(13).Name = "X_v_dev";
    data.Datasets(13).Value = h5read(filename, "/X_v_dev");
    
    data.Datasets(14).Name = "X_v_test";
    data.Datasets(14).Value = h5read(filename, "/X_v_test");
    
    data.Datasets(15).Name = "X_v_var";
    data.Datasets(15).Value = h5read(filename, "/X_v_var");
    
    data.Datasets(16).Name = "Y_dev";
    data.Datasets(16).Value = h5read(filename, "/Y_dev");
    
    data.Datasets(17).Name = "Y_test";
    data.Datasets(17).Value = h5read(filename, "/Y_test");
end
