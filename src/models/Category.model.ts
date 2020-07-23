import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt, AutoIncrement, BelongsTo, BelongsToMany, ForeignKey } from "sequelize-typescript";
import CategoryGroup from "./CategoryGroup.model";

@Table
export default class Category extends Model<Category> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: number;

    @Column
    name: string;

    @ForeignKey(() => CategoryGroup)
    @Column
    categoryGroupId: number;

    @BelongsTo(() => CategoryGroup)
    categoryGroup: CategoryGroup;

    @CreatedAt
    createdAt: Date;
}