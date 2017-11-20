function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../data/traintest.mat');

	%% TODO create train_features
    N = length(train_imagenames);
    for i = 1:N
        load(strcat('../data/', strrep(train_imagenames{i}, '.jpg', '.mat')), ...
            'wordMap');
        train_features(:, i) = getImageFeaturesSPM(3, wordMap, size(dictionary, 2));
        %train_features(:, i) = getImageFeatures(wordMap, size(dictionary, 2));
    end
    
	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end