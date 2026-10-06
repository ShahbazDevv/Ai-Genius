// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SavedItemsTable extends SavedItems
    with TableInfo<$SavedItemsTable, SavedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _storeUrlMeta = const VerificationMeta(
    'storeUrl',
  );
  @override
  late final GeneratedColumn<String> storeUrl = GeneratedColumn<String>(
    'store_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _availabilityMeta = const VerificationMeta(
    'availability',
  );
  @override
  late final GeneratedColumn<String> availability = GeneratedColumn<String>(
    'availability',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('In stock'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Curated catalog'),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<String> lastUpdated = GeneratedColumn<String>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productCountMeta = const VerificationMeta(
    'productCount',
  );
  @override
  late final GeneratedColumn<int> productCount = GeneratedColumn<int>(
    'product_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('valid'),
  );
  static const VerificationMeta _productJsonMeta = const VerificationMeta(
    'productJson',
  );
  @override
  late final GeneratedColumn<String> productJson = GeneratedColumn<String>(
    'product_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemType,
    name,
    description,
    price,
    currency,
    imageUrl,
    storeName,
    storeUrl,
    category,
    tagsJson,
    availability,
    source,
    lastUpdated,
    reason,
    productCount,
    icon,
    status,
    productJson,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('store_url')) {
      context.handle(
        _storeUrlMeta,
        storeUrl.isAcceptableOrUnknown(data['store_url']!, _storeUrlMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('availability')) {
      context.handle(
        _availabilityMeta,
        availability.isAcceptableOrUnknown(
          data['availability']!,
          _availabilityMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('product_count')) {
      context.handle(
        _productCountMeta,
        productCount.isAcceptableOrUnknown(
          data['product_count']!,
          _productCountMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('product_json')) {
      context.handle(
        _productJsonMeta,
        productJson.isAcceptableOrUnknown(
          data['product_json']!,
          _productJsonMeta,
        ),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, itemType};
  @override
  SavedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      )!,
      storeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_url'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      availability: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_updated'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      productCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_count'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      productJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_json'],
      ),
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedItemsTable createAlias(String alias) {
    return $SavedItemsTable(attachedDatabase, alias);
  }
}

class SavedItem extends DataClass implements Insertable<SavedItem> {
  final String id;
  final String itemType;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String imageUrl;
  final String storeName;
  final String storeUrl;
  final String category;
  final String tagsJson;
  final String availability;
  final String source;
  final String lastUpdated;
  final String? reason;
  final int productCount;
  final String? icon;
  final String status;
  final String? productJson;
  final DateTime savedAt;
  const SavedItem({
    required this.id,
    required this.itemType,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.storeName,
    required this.storeUrl,
    required this.category,
    required this.tagsJson,
    required this.availability,
    required this.source,
    required this.lastUpdated,
    this.reason,
    required this.productCount,
    this.icon,
    required this.status,
    this.productJson,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_type'] = Variable<String>(itemType);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    map['image_url'] = Variable<String>(imageUrl);
    map['store_name'] = Variable<String>(storeName);
    map['store_url'] = Variable<String>(storeUrl);
    map['category'] = Variable<String>(category);
    map['tags_json'] = Variable<String>(tagsJson);
    map['availability'] = Variable<String>(availability);
    map['source'] = Variable<String>(source);
    map['last_updated'] = Variable<String>(lastUpdated);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['product_count'] = Variable<int>(productCount);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || productJson != null) {
      map['product_json'] = Variable<String>(productJson);
    }
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedItemsCompanion toCompanion(bool nullToAbsent) {
    return SavedItemsCompanion(
      id: Value(id),
      itemType: Value(itemType),
      name: Value(name),
      description: Value(description),
      price: Value(price),
      currency: Value(currency),
      imageUrl: Value(imageUrl),
      storeName: Value(storeName),
      storeUrl: Value(storeUrl),
      category: Value(category),
      tagsJson: Value(tagsJson),
      availability: Value(availability),
      source: Value(source),
      lastUpdated: Value(lastUpdated),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      productCount: Value(productCount),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      status: Value(status),
      productJson: productJson == null && nullToAbsent
          ? const Value.absent()
          : Value(productJson),
      savedAt: Value(savedAt),
    );
  }

  factory SavedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedItem(
      id: serializer.fromJson<String>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      storeName: serializer.fromJson<String>(json['storeName']),
      storeUrl: serializer.fromJson<String>(json['storeUrl']),
      category: serializer.fromJson<String>(json['category']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      availability: serializer.fromJson<String>(json['availability']),
      source: serializer.fromJson<String>(json['source']),
      lastUpdated: serializer.fromJson<String>(json['lastUpdated']),
      reason: serializer.fromJson<String?>(json['reason']),
      productCount: serializer.fromJson<int>(json['productCount']),
      icon: serializer.fromJson<String?>(json['icon']),
      status: serializer.fromJson<String>(json['status']),
      productJson: serializer.fromJson<String?>(json['productJson']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemType': serializer.toJson<String>(itemType),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'storeName': serializer.toJson<String>(storeName),
      'storeUrl': serializer.toJson<String>(storeUrl),
      'category': serializer.toJson<String>(category),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'availability': serializer.toJson<String>(availability),
      'source': serializer.toJson<String>(source),
      'lastUpdated': serializer.toJson<String>(lastUpdated),
      'reason': serializer.toJson<String?>(reason),
      'productCount': serializer.toJson<int>(productCount),
      'icon': serializer.toJson<String?>(icon),
      'status': serializer.toJson<String>(status),
      'productJson': serializer.toJson<String?>(productJson),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedItem copyWith({
    String? id,
    String? itemType,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? imageUrl,
    String? storeName,
    String? storeUrl,
    String? category,
    String? tagsJson,
    String? availability,
    String? source,
    String? lastUpdated,
    Value<String?> reason = const Value.absent(),
    int? productCount,
    Value<String?> icon = const Value.absent(),
    String? status,
    Value<String?> productJson = const Value.absent(),
    DateTime? savedAt,
  }) => SavedItem(
    id: id ?? this.id,
    itemType: itemType ?? this.itemType,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    imageUrl: imageUrl ?? this.imageUrl,
    storeName: storeName ?? this.storeName,
    storeUrl: storeUrl ?? this.storeUrl,
    category: category ?? this.category,
    tagsJson: tagsJson ?? this.tagsJson,
    availability: availability ?? this.availability,
    source: source ?? this.source,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    reason: reason.present ? reason.value : this.reason,
    productCount: productCount ?? this.productCount,
    icon: icon.present ? icon.value : this.icon,
    status: status ?? this.status,
    productJson: productJson.present ? productJson.value : this.productJson,
    savedAt: savedAt ?? this.savedAt,
  );
  SavedItem copyWithCompanion(SavedItemsCompanion data) {
    return SavedItem(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      storeUrl: data.storeUrl.present ? data.storeUrl.value : this.storeUrl,
      category: data.category.present ? data.category.value : this.category,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      availability: data.availability.present
          ? data.availability.value
          : this.availability,
      source: data.source.present ? data.source.value : this.source,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
      reason: data.reason.present ? data.reason.value : this.reason,
      productCount: data.productCount.present
          ? data.productCount.value
          : this.productCount,
      icon: data.icon.present ? data.icon.value : this.icon,
      status: data.status.present ? data.status.value : this.status,
      productJson: data.productJson.present
          ? data.productJson.value
          : this.productJson,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedItem(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('storeName: $storeName, ')
          ..write('storeUrl: $storeUrl, ')
          ..write('category: $category, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('availability: $availability, ')
          ..write('source: $source, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('reason: $reason, ')
          ..write('productCount: $productCount, ')
          ..write('icon: $icon, ')
          ..write('status: $status, ')
          ..write('productJson: $productJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemType,
    name,
    description,
    price,
    currency,
    imageUrl,
    storeName,
    storeUrl,
    category,
    tagsJson,
    availability,
    source,
    lastUpdated,
    reason,
    productCount,
    icon,
    status,
    productJson,
    savedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedItem &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.imageUrl == this.imageUrl &&
          other.storeName == this.storeName &&
          other.storeUrl == this.storeUrl &&
          other.category == this.category &&
          other.tagsJson == this.tagsJson &&
          other.availability == this.availability &&
          other.source == this.source &&
          other.lastUpdated == this.lastUpdated &&
          other.reason == this.reason &&
          other.productCount == this.productCount &&
          other.icon == this.icon &&
          other.status == this.status &&
          other.productJson == this.productJson &&
          other.savedAt == this.savedAt);
}

class SavedItemsCompanion extends UpdateCompanion<SavedItem> {
  final Value<String> id;
  final Value<String> itemType;
  final Value<String> name;
  final Value<String> description;
  final Value<double> price;
  final Value<String> currency;
  final Value<String> imageUrl;
  final Value<String> storeName;
  final Value<String> storeUrl;
  final Value<String> category;
  final Value<String> tagsJson;
  final Value<String> availability;
  final Value<String> source;
  final Value<String> lastUpdated;
  final Value<String?> reason;
  final Value<int> productCount;
  final Value<String?> icon;
  final Value<String> status;
  final Value<String?> productJson;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const SavedItemsCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.availability = const Value.absent(),
    this.source = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.reason = const Value.absent(),
    this.productCount = const Value.absent(),
    this.icon = const Value.absent(),
    this.status = const Value.absent(),
    this.productJson = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedItemsCompanion.insert({
    required String id,
    required String itemType,
    required String name,
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.availability = const Value.absent(),
    this.source = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.reason = const Value.absent(),
    this.productCount = const Value.absent(),
    this.icon = const Value.absent(),
    this.status = const Value.absent(),
    this.productJson = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemType = Value(itemType),
       name = Value(name);
  static Insertable<SavedItem> custom({
    Expression<String>? id,
    Expression<String>? itemType,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? imageUrl,
    Expression<String>? storeName,
    Expression<String>? storeUrl,
    Expression<String>? category,
    Expression<String>? tagsJson,
    Expression<String>? availability,
    Expression<String>? source,
    Expression<String>? lastUpdated,
    Expression<String>? reason,
    Expression<int>? productCount,
    Expression<String>? icon,
    Expression<String>? status,
    Expression<String>? productJson,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (imageUrl != null) 'image_url': imageUrl,
      if (storeName != null) 'store_name': storeName,
      if (storeUrl != null) 'store_url': storeUrl,
      if (category != null) 'category': category,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (availability != null) 'availability': availability,
      if (source != null) 'source': source,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (reason != null) 'reason': reason,
      if (productCount != null) 'product_count': productCount,
      if (icon != null) 'icon': icon,
      if (status != null) 'status': status,
      if (productJson != null) 'product_json': productJson,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? itemType,
    Value<String>? name,
    Value<String>? description,
    Value<double>? price,
    Value<String>? currency,
    Value<String>? imageUrl,
    Value<String>? storeName,
    Value<String>? storeUrl,
    Value<String>? category,
    Value<String>? tagsJson,
    Value<String>? availability,
    Value<String>? source,
    Value<String>? lastUpdated,
    Value<String?>? reason,
    Value<int>? productCount,
    Value<String?>? icon,
    Value<String>? status,
    Value<String?>? productJson,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return SavedItemsCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      storeUrl: storeUrl ?? this.storeUrl,
      category: category ?? this.category,
      tagsJson: tagsJson ?? this.tagsJson,
      availability: availability ?? this.availability,
      source: source ?? this.source,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      reason: reason ?? this.reason,
      productCount: productCount ?? this.productCount,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      productJson: productJson ?? this.productJson,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (storeUrl.present) {
      map['store_url'] = Variable<String>(storeUrl.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (availability.present) {
      map['availability'] = Variable<String>(availability.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<String>(lastUpdated.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (productCount.present) {
      map['product_count'] = Variable<int>(productCount.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (productJson.present) {
      map['product_json'] = Variable<String>(productJson.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('storeName: $storeName, ')
          ..write('storeUrl: $storeUrl, ')
          ..write('category: $category, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('availability: $availability, ')
          ..write('source: $source, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('reason: $reason, ')
          ..write('productCount: $productCount, ')
          ..write('icon: $icon, ')
          ..write('status: $status, ')
          ..write('productJson: $productJson, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryTable extends History with TableInfo<$HistoryTable, HistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestDataMeta = const VerificationMeta(
    'requestData',
  );
  @override
  late final GeneratedColumn<String> requestData = GeneratedColumn<String>(
    'request_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recommendationsJsonMeta =
      const VerificationMeta('recommendationsJson');
  @override
  late final GeneratedColumn<String> recommendationsJson =
      GeneratedColumn<String>(
        'recommendations_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subtitle,
    requestData,
    recommendationsJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    } else if (isInserting) {
      context.missing(_subtitleMeta);
    }
    if (data.containsKey('request_data')) {
      context.handle(
        _requestDataMeta,
        requestData.isAcceptableOrUnknown(
          data['request_data']!,
          _requestDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestDataMeta);
    }
    if (data.containsKey('recommendations_json')) {
      context.handle(
        _recommendationsJsonMeta,
        recommendationsJson.isAcceptableOrUnknown(
          data['recommendations_json']!,
          _recommendationsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendationsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      )!,
      requestData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_data'],
      )!,
      recommendationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HistoryTable createAlias(String alias) {
    return $HistoryTable(attachedDatabase, alias);
  }
}

class HistoryData extends DataClass implements Insertable<HistoryData> {
  final String id;
  final String title;
  final String subtitle;
  final String requestData;
  final String recommendationsJson;
  final DateTime createdAt;
  const HistoryData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.requestData,
    required this.recommendationsJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['subtitle'] = Variable<String>(subtitle);
    map['request_data'] = Variable<String>(requestData);
    map['recommendations_json'] = Variable<String>(recommendationsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HistoryCompanion toCompanion(bool nullToAbsent) {
    return HistoryCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: Value(subtitle),
      requestData: Value(requestData),
      recommendationsJson: Value(recommendationsJson),
      createdAt: Value(createdAt),
    );
  }

  factory HistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      requestData: serializer.fromJson<String>(json['requestData']),
      recommendationsJson: serializer.fromJson<String>(
        json['recommendationsJson'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String>(subtitle),
      'requestData': serializer.toJson<String>(requestData),
      'recommendationsJson': serializer.toJson<String>(recommendationsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HistoryData copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? requestData,
    String? recommendationsJson,
    DateTime? createdAt,
  }) => HistoryData(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    requestData: requestData ?? this.requestData,
    recommendationsJson: recommendationsJson ?? this.recommendationsJson,
    createdAt: createdAt ?? this.createdAt,
  );
  HistoryData copyWithCompanion(HistoryCompanion data) {
    return HistoryData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      requestData: data.requestData.present
          ? data.requestData.value
          : this.requestData,
      recommendationsJson: data.recommendationsJson.present
          ? data.recommendationsJson.value
          : this.recommendationsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('requestData: $requestData, ')
          ..write('recommendationsJson: $recommendationsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subtitle,
    requestData,
    recommendationsJson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryData &&
          other.id == this.id &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.requestData == this.requestData &&
          other.recommendationsJson == this.recommendationsJson &&
          other.createdAt == this.createdAt);
}

class HistoryCompanion extends UpdateCompanion<HistoryData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> subtitle;
  final Value<String> requestData;
  final Value<String> recommendationsJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HistoryCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.requestData = const Value.absent(),
    this.recommendationsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryCompanion.insert({
    required String id,
    required String title,
    required String subtitle,
    required String requestData,
    required String recommendationsJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       subtitle = Value(subtitle),
       requestData = Value(requestData),
       recommendationsJson = Value(recommendationsJson),
       createdAt = Value(createdAt);
  static Insertable<HistoryData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? requestData,
    Expression<String>? recommendationsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (requestData != null) 'request_data': requestData,
      if (recommendationsJson != null)
        'recommendations_json': recommendationsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? subtitle,
    Value<String>? requestData,
    Value<String>? recommendationsJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HistoryCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      requestData: requestData ?? this.requestData,
      recommendationsJson: recommendationsJson ?? this.recommendationsJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (requestData.present) {
      map['request_data'] = Variable<String>(requestData.value);
    }
    if (recommendationsJson.present) {
      map['recommendations_json'] = Variable<String>(recommendationsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('requestData: $requestData, ')
          ..write('recommendationsJson: $recommendationsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedItemsTable savedItems = $SavedItemsTable(this);
  late final $HistoryTable history = $HistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedItems, history];
}

typedef $$SavedItemsTableCreateCompanionBuilder =
    SavedItemsCompanion Function({
      required String id,
      required String itemType,
      required String name,
      Value<String> description,
      Value<double> price,
      Value<String> currency,
      Value<String> imageUrl,
      Value<String> storeName,
      Value<String> storeUrl,
      Value<String> category,
      Value<String> tagsJson,
      Value<String> availability,
      Value<String> source,
      Value<String> lastUpdated,
      Value<String?> reason,
      Value<int> productCount,
      Value<String?> icon,
      Value<String> status,
      Value<String?> productJson,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });
typedef $$SavedItemsTableUpdateCompanionBuilder =
    SavedItemsCompanion Function({
      Value<String> id,
      Value<String> itemType,
      Value<String> name,
      Value<String> description,
      Value<double> price,
      Value<String> currency,
      Value<String> imageUrl,
      Value<String> storeName,
      Value<String> storeUrl,
      Value<String> category,
      Value<String> tagsJson,
      Value<String> availability,
      Value<String> source,
      Value<String> lastUpdated,
      Value<String?> reason,
      Value<int> productCount,
      Value<String?> icon,
      Value<String> status,
      Value<String?> productJson,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

class $$SavedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedItemsTable> {
  $$SavedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeUrl => $composableBuilder(
    column: $table.storeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productJson => $composableBuilder(
    column: $table.productJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedItemsTable> {
  $$SavedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeUrl => $composableBuilder(
    column: $table.storeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productJson => $composableBuilder(
    column: $table.productJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedItemsTable> {
  $$SavedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get storeUrl =>
      $composableBuilder(column: $table.storeUrl, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get availability => $composableBuilder(
    column: $table.availability,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get productJson => $composableBuilder(
    column: $table.productJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$SavedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedItemsTable,
          SavedItem,
          $$SavedItemsTableFilterComposer,
          $$SavedItemsTableOrderingComposer,
          $$SavedItemsTableAnnotationComposer,
          $$SavedItemsTableCreateCompanionBuilder,
          $$SavedItemsTableUpdateCompanionBuilder,
          (
            SavedItem,
            BaseReferences<_$AppDatabase, $SavedItemsTable, SavedItem>,
          ),
          SavedItem,
          PrefetchHooks Function()
        > {
  $$SavedItemsTableTableManager(_$AppDatabase db, $SavedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> storeName = const Value.absent(),
                Value<String> storeUrl = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> availability = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> lastUpdated = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> productCount = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> productJson = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsCompanion(
                id: id,
                itemType: itemType,
                name: name,
                description: description,
                price: price,
                currency: currency,
                imageUrl: imageUrl,
                storeName: storeName,
                storeUrl: storeUrl,
                category: category,
                tagsJson: tagsJson,
                availability: availability,
                source: source,
                lastUpdated: lastUpdated,
                reason: reason,
                productCount: productCount,
                icon: icon,
                status: status,
                productJson: productJson,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemType,
                required String name,
                Value<String> description = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> storeName = const Value.absent(),
                Value<String> storeUrl = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> availability = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> lastUpdated = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> productCount = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> productJson = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsCompanion.insert(
                id: id,
                itemType: itemType,
                name: name,
                description: description,
                price: price,
                currency: currency,
                imageUrl: imageUrl,
                storeName: storeName,
                storeUrl: storeUrl,
                category: category,
                tagsJson: tagsJson,
                availability: availability,
                source: source,
                lastUpdated: lastUpdated,
                reason: reason,
                productCount: productCount,
                icon: icon,
                status: status,
                productJson: productJson,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedItemsTable, SavedItem>(table),
                  BaseReferences<_$AppDatabase, $SavedItemsTable, SavedItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedItemsTable,
      SavedItem,
      $$SavedItemsTableFilterComposer,
      $$SavedItemsTableOrderingComposer,
      $$SavedItemsTableAnnotationComposer,
      $$SavedItemsTableCreateCompanionBuilder,
      $$SavedItemsTableUpdateCompanionBuilder,
      (SavedItem, BaseReferences<_$AppDatabase, $SavedItemsTable, SavedItem>),
      SavedItem,
      PrefetchHooks Function()
    >;
typedef $$HistoryTableCreateCompanionBuilder =
    HistoryCompanion Function({
      required String id,
      required String title,
      required String subtitle,
      required String requestData,
      required String recommendationsJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$HistoryTableUpdateCompanionBuilder =
    HistoryCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> subtitle,
      Value<String> requestData,
      Value<String> recommendationsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HistoryTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestData => $composableBuilder(
    column: $table.requestData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendationsJson => $composableBuilder(
    column: $table.recommendationsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestData => $composableBuilder(
    column: $table.requestData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendationsJson => $composableBuilder(
    column: $table.recommendationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get requestData => $composableBuilder(
    column: $table.requestData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendationsJson => $composableBuilder(
    column: $table.recommendationsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoryTable,
          HistoryData,
          $$HistoryTableFilterComposer,
          $$HistoryTableOrderingComposer,
          $$HistoryTableAnnotationComposer,
          $$HistoryTableCreateCompanionBuilder,
          $$HistoryTableUpdateCompanionBuilder,
          (
            HistoryData,
            BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>,
          ),
          HistoryData,
          PrefetchHooks Function()
        > {
  $$HistoryTableTableManager(_$AppDatabase db, $HistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subtitle = const Value.absent(),
                Value<String> requestData = const Value.absent(),
                Value<String> recommendationsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoryCompanion(
                id: id,
                title: title,
                subtitle: subtitle,
                requestData: requestData,
                recommendationsJson: recommendationsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String subtitle,
                required String requestData,
                required String recommendationsJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => HistoryCompanion.insert(
                id: id,
                title: title,
                subtitle: subtitle,
                requestData: requestData,
                recommendationsJson: recommendationsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HistoryTable, HistoryData>(table),
                  BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryTable,
      HistoryData,
      $$HistoryTableFilterComposer,
      $$HistoryTableOrderingComposer,
      $$HistoryTableAnnotationComposer,
      $$HistoryTableCreateCompanionBuilder,
      $$HistoryTableUpdateCompanionBuilder,
      (HistoryData, BaseReferences<_$AppDatabase, $HistoryTable, HistoryData>),
      HistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedItemsTableTableManager get savedItems =>
      $$SavedItemsTableTableManager(_db, _db.savedItems);
  $$HistoryTableTableManager get history =>
      $$HistoryTableTableManager(_db, _db.history);
}
