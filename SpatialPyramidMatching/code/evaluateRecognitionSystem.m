function [C, conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');

	%% TODO Implement your code here
    C = zeros(8,8);

    testInd = length(test_imagenames);
    for i=1:testInd
        guess = guessImage(strcat('../data/',test_imagenames{i}));
        
        % predicted label for column index
        predLabel = find(strcmp(mapping, guess));
        
        % real label for row index
        realLabel = test_labels(i);
        
        % the diagnal of C is for correct prediction
        % the off diagnal of C is for wrong prediction
        C(realLabel, predLabel) = C(realLabel, predLabel) + 1;
        if(realLabel ~= predLabel)
            fprintf('Fail: %s should be %s\n', guess, test_labels(i));
        end
    end
 
    accuracy_art_gallery = C(1, 1) / sum(C(1, :));
    accuracy_computer_room = C(2, 2) / sum(C(2, :));
    accuracy_garden = C(3, 3) / sum(C(3, :));
    accuracy_ice_skating = C(4, 4) / sum(C(4, :));
    accuracy_library = C(5, 5) / sum(C(5, :));
    accuracy_mountain = C(6, 6) / sum(C(6, :));
    accuracy_ocean = C(7, 7) / sum(C(7, :));
    accuracy_tennis_court = C(8, 8) / sum(C(8, :));
    
    fprintf('The confusion matrix is:\n %s\n', C);
    fprintf('The accuracy for art gallery images is: %s\n', accuracy_art_gallery);
    fprintf('The accuracy for computer room images is: %s\n', accuracy_computer_room);
    fprintf('The accuracy for garden images is: %s\n', accuracy_garden);
    fprintf('The accuracy for art ice skating images is: %s\n', accuracy_ice_skating);
    fprintf('The accuracy for library images is: %s\n', accuracy_library);
    fprintf('The accuracy for mountain images is: %s\n', accuracy_mountain);
    fprintf('The accuracy for ocean images is: %s\n', accuracy_ocean);
    fprintf('The accuracy for tennis court images is: %s\n', accuracy_tennis_court);
    
    conf = trace(C) / sum(C(:));

end